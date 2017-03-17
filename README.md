# GemCollector
Collect gems used by applications.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'gem_collector'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install gem_collector
```

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

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
