class GemCollector::DeleteRepository
  def run(repository)
    octokit = GemCollector::OctokitProvider.get(repository.site)
    begin
      GemCollector::Webhooks.new(octokit).remove(repository.full_name)
    rescue Octokit::Error
      Rails.logger.warn("Cannot check webhook in #{repository.full_name}")
    end

    repository.destroy!
  end
end
