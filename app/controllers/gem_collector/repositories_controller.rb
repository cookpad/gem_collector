class GemCollector::RepositoriesController < GemCollector::ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[github_webhook]

  def index
    @repositories = GemCollector::Repository.all_with_version_point
    render 'gem_collector/repositories/index'
  end

  def show
    @repository = GemCollector::Repository.find(params[:id])
  end

  def new
    @repository = GemCollector::Repository.new
  end

  def create
    form = params.require(:repository)
    repository = GemCollector::CreateRepository.new.run(
      site: form[:site],
      full_name: form[:full_name],
    )
    redirect_to repository_path(repository.id)
  rescue GemCollector::CreateRepository::Error => e
    redirect_to repositories_path, alert: e.message
  end

  def destroy
    repository = GemCollector::Repository.find(params[:id])
    GemCollector::DeleteRepository.new.run(repository)
    redirect_to repositories_path
  end

  def github_webhook
    event = request.headers['X-GitHub-Event']
    case event
    when 'ping'
      render plain: 'pong'
    when 'push'
      html_url = params[:repository][:html_url]
      site = Addressable::URI.parse(html_url).host
      unless has_valid_signature?(site)
        render status: 403, plain: "Signatures didn't match"
        return
      end

      repository = GemCollector::UpdateRepository.new.run(
        repository_id: params[:repository][:id],
        full_name: params[:repository][:full_name],
        html_url: html_url,
        ssh_url: params[:repository][:ssh_url],
      )
      GemCollector::UpdateGemfileJob.perform_later(repository.id)
      render plain: 'OK'
    else
      render status: 400, plain: "Unknown event #{event}"
    end
  end

  private

  # https://developer.github.com/webhooks/securing/
  def has_valid_signature?(site)
    secret = Rails.application.config.octokit.fetch(site)['webhook_secret']
    if secret
      request.body.rewind
      payload_body = request.body.read
      given_signature = request.headers['X-Hub-Signature']
      unless given_signature
        return false
      end
      expected_signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret, payload_body)
      Rack::Utils.secure_compare(expected_signature, given_signature)
    else
      # No validation
      true
    end
  end

  def default_github_site
    ENV['DEFAULT_GITHUB_SITE'] || 'github.com'
  end
  helper_method :default_github_site
end
