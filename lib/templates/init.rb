if yes?("Generate home controller?")
  File::unlink "public/index.html"
  generate(:controller, "home index about contact")
  route "root :to => 'home#index'"
end

if yes?("Install gems?")
  ## Access
  gem "devise"
  generate("devise:install")
  model_name = ask("What would you like the user model to be called? [user]")
  model_name = "user" if model_name.blank?
  generate("devise", model_name)
  gem "cancan"
  ## Storage
  gem "carrierwave"
  ## View
  gem "simple_form"
  generate("simple_form:install", "--bootstrap")
  gem "dynamic_form"
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
  rake "gems:install"
end

if yes?("Install Twitter Boostrap to 'vendor/assets/' ?")
  require 'zip/zip'
  bootstrap_zip = open("http://twitter.github.com/bootstrap/assets/bootstrap.zip")
  Zip::ZipFile.open(bootstrap_zip) do |zipfile|
    zipfile.each{|entry|
      base_name = File::basename(entry.name)
      case entry.to_s
      when /bootstrap\/js\/.+/
        vendor("assets/javascripts/#{base_name}", entry.get_input_stream().read())
      when /bootstrap\/css\/.+/
        vendor("assets/stylesheets/#{base_name}", entry.get_input_stream().read().gsub(/".*\/(.*\.png)"/, '"\1"'))
      when /bootstrap\/img\/.+/
        vendor("assets/images/#{base_name}", entry.get_input_stream().read())
      end
    }
  end
end