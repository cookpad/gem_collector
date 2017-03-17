module GemCollector
  class Engine < ::Rails::Engine
    isolate_namespace GemCollector

    config.autoload_paths << root.join('lib/autoload').to_s
    config.eager_load_paths << root.join('lib/autoload').to_s

    initializer 'gem_collector.octokit' do |app|
      app.config.octokit = app.config_for(:octokit)
    end
  end
end
