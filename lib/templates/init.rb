if yes?("Generate home controller?")
  File::unlink "public/index.html"
  generate(:controller, "home index about contact")
  route "root :to => 'home#index'"
end

if yes?("Install gems?")
  ## Access
  if yes?("Install member system? (devise, cancan)")
    gem "devise"
    generate("devise:install")
    model_name = ask("What would you like the user model to be called? [user]")
    model_name = "user" if model_name.blank?
    generate("devise", model_name)
    gem "cancan"
  end
  ## Storage
  gem "carrierwave"
  ## View
  gem "simple_form"
  generate("simple_form:install", "--bootstrap")
  gem "dynamic_form"
  gem "cocoon"
  gem "will_paginate"
  ## Markup
  gem "rdiscount"
  ## i18n
  gem "rails-i18n"
end

## Dev
gem_group :development do
  gem "faker"
  gem "rubyzip"
end

rake "db:migrate"
