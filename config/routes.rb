GemCollector::Engine.routes.draw do
  resources :repositories, only: %i[index show new create destroy]
  post '/github-webhook' => 'repositories#github_webhook'

  get '/gems' => 'repository_gems#index', as: :repository_gems
  get '/gems/:name' => 'repository_gems#show', as: :repository_gem
  get '/gems/:name/new_issue' => 'gem_news#new', as: :new_gem_news
  post '/gems/:name/new_issue' => 'gem_news#create', as: :create_gem_news
end
