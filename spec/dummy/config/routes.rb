Rails.application.routes.draw do
  mount GemCollector::Engine => "/gem_collector"
end
