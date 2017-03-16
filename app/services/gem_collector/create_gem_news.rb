class GemCollector::CreateGemNews
  def initialize(homepage, gem_name, title, body, from_version, to_version)
    @gem_name, @body, @from_version, @to_version = gem_name, body, from_version, to_version
    @title = title.present? ? title : %!Please check for "#{gem_name}"!
  end

  # @params [Array<Repository>] repositories
  def run(repositories)
    repositories.each {|repo| create_news_issue(repo) }
  end

  private def create_news_issue(repo)
    octokit = GemCollector::OctokitProvider.get(repo.site)
    begin
      octokit.create_issue(repo.full_name, @title, issue_body)
    rescue Octokit::NotFound
      raise Error.new("Cannot find repository #{repo.full_name}. @#{octokit.login} cannot find it")
    end
  end

  private def issue_body
    [<<-NEWS_HEADER.strip_heredoc, '', '---', '', @body].join("\n")
    This issue was delivered from [gem_collector](homepage) because this repository depends on #{gem_name_with_version}.
    NEWS_HEADER
  end

  private def gem_name_with_version
    [
      %!"#{@gem_name}"!,
      @from_version.present? ? "(>= #{@from_version})" : nil,
      @to_version.present? ? "(< #{@to_version})" : nil,
    ].compact.join(' ')
  end

  class Error < ::StandardError
  end
end
