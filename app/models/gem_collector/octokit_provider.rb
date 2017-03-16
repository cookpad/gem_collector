module GemCollector::OctokitProvider
  def self.get(site)
    conf = Rails.application.config.octokit.fetch(site)
    Octokit::Client.new(
      api_endpoint: conf['api_endpoint'],
      web_endpoint: conf['web_endpoint'],
      access_token: conf['access_token'],
    )
  end
end
