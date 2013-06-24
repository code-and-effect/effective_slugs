$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "effective_slugs/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "Effective Slugs"
  s.version     = EffectiveSlugs::VERSION
  s.email       = ["info@codeandeffect.com"]
  s.authors     = ["Code and Effect"]
  s.homepage    = "https://github.com/code-and-effect/effective_slugs"
  s.summary     = "Effectively create url-appropriate slugs for any object"
  s.description = "Generates a URL-appropriate slug, as required, when saving a record. Also overrides ActiveRecord .find() methods to accept the slug, or an id as the parameter."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "psych"
  s.add_development_dependency "sqlite3"

  # s.add_development_dependency "capybara"
  # s.add_development_dependency "guard"
  # s.add_development_dependency "guard-rspec"
  # s.add_development_dependency "guard-livereload"
  # s.add_development_dependency "poltergeist"
  # s.add_development_dependency "shoulda-matchers"
end
