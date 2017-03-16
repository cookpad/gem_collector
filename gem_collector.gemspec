$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "gem_collector/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gem_collector"
  s.version     = GemCollector::VERSION
  s.authors     = ["Kohei Suzuki"]
  s.email       = ["kohei-suzuki@cookpad.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of GemCollector."
  s.description = "TODO: Description of GemCollector."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.2"

  s.add_development_dependency "pg"
end
