ENV['RAILS_ENV'] ||= 'test'
require File.expand_path("../../spec/dummy/config/environment.rb", __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'factory_bot_rails'
require 'autodoc'

Autodoc.configuration.path = 'doc'
Autodoc.configuration.toc  = true
Autodoc.configuration.suppressed_response_header = %w[
  ETag
  X-Request-Id
  X-Runtime
]

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
end
