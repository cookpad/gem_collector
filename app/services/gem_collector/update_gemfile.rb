require 'find'

class GemCollector::UpdateGemfile
  def run(repository)
    Dir.mktmpdir("gem_collector_update_gemfile_#{repository.id}") do |dir|
      dir_path = Pathname.new(dir)
      system!('git', 'clone', '--depth=1', repository.ssh_url, dir)
      retry_on_serialization_failure(tries: 3) do
        GemCollector::RepositoryGem.transaction(isolation: :serializable) do
          GemCollector::RepositoryGem.where(repository_id: repository.id).delete_all
          each_gemfile_lock(dir) do |path|
            update_gemfile_lock(repository, dir_path, path)
          end
          repository.touch(:updated_at)
        end
      end
    end
  end

  private

  def system!(*args)
    unless system(*args)
      raise "Command execution failure: #{args}"
    end
  end

  def retry_on_serialization_failure(tries:, &block)
    tries.times do |i|
      begin
        return block.call
      rescue ActiveRecord::StatementInvalid => e
        if e.cause.is_a?(PG::TRSerializationFailure)
          $stderr.puts "#{e.cause.class}: #{e.cause.message}"
          sleep(2**i)
          $stderr.puts "Retrying... (try: #{i+1})"
        else
          raise e
        end
      end
    end
    raise 'Too many serialization failures'
  end

  def each_gemfile_lock(dir, &block)
    Find.find(dir) do |f|
      if f == '.git'
        Find.prune
      end
      path = Pathname.new(f)
      if path.basename.to_s == 'Gemfile.lock'
        block.call(path)
      end
    end
  end

  def update_gemfile_lock(repository, dir, path)
    lockfile_parser = Bundler::LockfileParser.new(path.read)
    lock_path = path.relative_path_from(dir).to_s
    records = lockfile_parser.specs.map do |spec|
      repository.repository_gems.build(path: lock_path, name: spec.name, version: spec.version.to_s)
    end
    GemCollector::RepositoryGem.import(records)
  end
end
