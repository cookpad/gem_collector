class GemCollector::CreateRepository
  def run(site:, full_name:)
    octokit = GemCollector::OctokitProvider.get(site)
    begin
      repo = octokit.repository(full_name)
    rescue Octokit::NotFound
      raise Error.new("Cannot find repository #{full_name}. @#{octokit.login} cannot find it")
    end

    repository = GemCollector::UpdateRepository.new.run(
      repository_id: repo[:id],
      full_name: repo[:full_name],
      html_url: repo[:html_url],
      ssh_url: repo[:ssh_url],
    )
    GemCollector::UpdateGemfile.new.run(repository)
    begin
      register_webhook(repository)
    rescue Octokit::NotFound
      raise Error.new("Cannot register webhook: @#{octokit.login} doesn't have admin permission on #{full_name}")
    end
    repository
  end

  def register_webhook(repository)
    octokit = GemCollector::OctokitProvider.get(repository.site)
    GemCollector::Webhooks.new(octokit).create(repository.full_name)
  end

  class Error < StandardError
  end
end
