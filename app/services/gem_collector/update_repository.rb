class GemCollector::UpdateRepository
  def run(repository_id:, full_name:, html_url:, ssh_url:)
    host = Addressable::URI.parse(html_url).host
    repo = GemCollector::Repository.find_or_initialize_by(site: host, repository_id: repository_id)
    repo.full_name = full_name
    repo.ssh_url = ssh_url
    repo.save!
    repo
  end
end
