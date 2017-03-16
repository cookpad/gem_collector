class GemCollector::Webhooks
  def initialize(octokit)
    @octokit = octokit
  end

  def create(full_name)
    hook = find_hook(full_name)
    unless hook
      @octokit.create_hook(full_name, WEBHOOK_NAME, { url: WEBHOOK_URL, content_type: 'json' }, { events: WEBHOOK_EVENTS, active: true })
    end
  end

  def remove(full_name)
    hook = find_hook(full_name)
    if hook
      @octokit.remove_hook(full_name, hook[:id])
    end
  end

  private

  WEBHOOK_NAME = 'web'
  WEBHOOK_URL = ENV['WEBHOOK_URL']
  WEBHOOK_EVENTS = ['push']

  def find_hook(full_name)
    @octokit.hooks(full_name).find { |hook| hook.name == WEBHOOK_NAME && hook.config.url == WEBHOOK_URL && hook.events == WEBHOOK_EVENTS }
  end
end
