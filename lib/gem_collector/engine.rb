module GemCollector
  class Engine < ::Rails::Engine
    isolate_namespace GemCollector

    config.autoload_paths << root.join('lib/autoload').to_s
    config.eager_load_paths << root.join('lib/autoload').to_s
  end
end
