$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tj_rails_extension/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tj_rails_extension"
  s.version     = TjRailsExtension::VERSION
  s.authors     = ["Tony Jian"]
  s.email       = ["tonytonyjan@gmail.com"]
  s.homepage    = "http://tonytonyjan.github.com"
  s.summary     = ""
  s.description = ""

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.8"
  # s.add_dependency "jquery-rails"
  s.add_dependency "devise"
  s.add_dependency "cancan"
  s.add_dependency "carrierwave"
  s.add_dependency "simple_form"
  s.add_dependency "dynamic_form"
  s.add_dependency "will_paginate"
  s.add_dependency "rdiscount"
  s.add_dependency "rails-i18n"

  s.add_development_dependency "sqlite3"
end
