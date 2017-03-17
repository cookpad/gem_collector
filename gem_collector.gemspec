$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'gem_collector/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'gem_collector'
  s.version     = GemCollector::VERSION
  s.authors     = ['Kohei Suzuki']
  s.email       = ['kohei-suzuki@cookpad.com']
  s.homepage    = 'https://github.com/cookpad/gem_collector'
  s.summary     = 'Collect gems used by applications'
  s.description = 'Collect gems used by applications'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'activerecord-import'
  s.add_dependency 'addressable'
  s.add_dependency 'haml'
  s.add_dependency 'octokit'
  s.add_dependency 'pg'
  s.add_dependency 'rails', '~> 5.0.2'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'
end
