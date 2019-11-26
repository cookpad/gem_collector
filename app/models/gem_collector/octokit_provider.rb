module GemCollector::OctokitProvider
  def self.get(site)
    conf = Rails.application.config.octokit.fetch(site.to_sym)
    options = {
      api_endpoint: conf[:api_endpoint],
      web_endpoint: conf[:web_endpoint],
      access_token: conf[:access_token],
    }.compact
    Octokit::Client.new(options)
  end
end
