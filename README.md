# GemCollector
[![Gem Version](https://badge.fury.io/rb/gem_collector.svg)](https://badge.fury.io/rb/gem_collector)
[![Build Status](https://travis-ci.org/cookpad/gem_collector.svg?branch=master)](https://travis-ci.org/cookpad/gem_collector)

Collect gems used by applications.

- Collect Gemfile.lock of the repository via GitHub webhook
- Show gem versions of the repository
- Show repositories using the gem
- Show "how up-to-date?" of the repository
- Create a issue to repositories using the gem

## Usage
There're two ways to add GemCollector webhook to repository.

### Add webhook from repository setting
Visit `https://github.com/:user/:repo/settings/hooks` and add `https://gem-collector.example.com/github-webhook` with `push` event.

### Add webhook from GemCollector
Visit `https://gem-collector.example.com/repositories/new` and enter repository location.
It will automatically add `ENV['WEBHOOK_URL']` with `push` event.

## Installation
### Gemfile
Add this line to your application's Gemfile:

```ruby
gem 'gem_collector'
```

### Octokit
Put config/octokit.yml like below.

```yaml
default: &default
  github.com:
    access_token: <%= ENV['GITHUB_ACCESS_TOKEN'] %>
    webhook_secret: <%= ENV['GITHUB_WEBHOOK_SECRET'] %>
  github-enterprise.example.com:
    api_endpoint: https://github-enterprise.example.com/api/v3
    web_endpoint: https://github-enterprise.example.com
    access_token: <%= ENV['GHE_ACCESS_TOKEN'] %>

development:
  <<: *default

production:
  <<: *default
```

### Database
Configure database.yml. GemCollector requires PostgreSQL.

```yaml
# config/database.yml
development:
  adapter: postgresql
  encoding: unicode
  database: gem_collector_development

production:
  url: <%= ENV['DATABASE_URL'] %>
```

### ActiveJob
Configure ActiveJob adapter. We're using [Barbeque](https://github.com/cookpad/barbeque), but other adapters should work.

```ruby
# config/initializers/barbeque.rb
Rails.application.configure do
  config.active_job.queue_adapter = :barbeque
end

BarbequeClient.configure do |config|
  config.application = 'gem-collector'
  config.default_queue = 'default'
  config.endpoint =
    if Rails.env.production?
      ENV.fetch('BARBEQUE_ENDPOINT')
    else
      ENV.fetch('BARBEQUE_ENDPOINT', 'http://localhost:3003')
    end
end
```

### Environment variables
- `WEBHOOK_URL` (required when `/repositories/new` is used)
  - URL to be added when the repository is registered from `/repositories/new`
  - Example: `https://gem-collector.example.com/github-webhook`
- `DEFAULT_GITHUB_SITE` (optional: default to `github.com`)
  - Placeholder site for `/repositories/new`
  - Example: `github-enterprise.example.com`

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
