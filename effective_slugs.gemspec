$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "effective_slugs/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "effective_slugs"
  s.version     = EffectiveSlugs::VERSION
  s.email       = ["info@codeandeffect.com"]
  s.authors     = ["Code and Effect"]
  s.homepage    = "https://github.com/code-and-effect/effective_slugs"
  s.summary     = "Automatically generate URL-appropriate slugs when saving a record. Rails 3 only."
  s.description = "Automatically generate URL-appropriate slugs when saving a record. Rails 3 only."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", ["~> 3.2"]

  # s.add_development_dependency "rspec-rails"
  # s.add_development_dependency "factory_girl_rails"
  # s.add_development_dependency "sqlite3"
end
