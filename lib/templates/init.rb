config = {}
if config[:install_gems] = yes?("Install gems?")
  if config[:create_devise_user] = yes?("Create user model for devise?")
    config[:user_model_name] = ask("What would you like the user model to be called? [user]")
    config[:user_model_name] = "user" if config[:user_model_name].blank?
  end
end
config[:gen_home_controller] = yes?("Generate home controller?")
config[:gen_scaffold] = yes?("Generate scaffold?")
config[:migrate] = yes?("migrate database?")


if config[:install_gems]
  ## Access
  gem "devise"
  generate("devise:install")
  generate("devise", config[:user_model_name]) if config[:user_model_name]
  gem "cancan"
  ## Storage
  gem "carrierwave"
  ## View
  gem "simple_form"
  generate("simple_form:install", "--bootstrap")
  gem "dynamic_form"
  gem "nested_form", github: 'ryanb/nested_form'
  gem "will_paginate"
  ## Markup
  gem "rdiscount"
  ## i18n
  gem "rails-i18n"

  ## Dev
  gem_group :development do
    gem "faker"
    gem "rubyzip"
  end
end

if config[:gen_home_controller]
  File::unlink "public/index.html" if File::exist? "public/index.html"
  generate(:controller, "home index about contact")
  route "root :to => 'home#index'"
end

if config[:gen_scaffold]
  directory File::join(File.dirname(__FILE__), "erb"), 'lib/templates/erb'
  directory File::join(File.dirname(__FILE__), "rails"), 'lib/templates/rails'

  application <<-eos
config.generators do |g|
      g.stylesheets false
    end
  eos
end

if config[:migrate]
  rake "db:migrate"
end