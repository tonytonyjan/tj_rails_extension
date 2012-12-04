require 'rails/generators'
require 'rails/generators/rails/app/app_generator'
generator = Rails::Generators::AppGenerator.new [Rails.root], {}, :destination_root => Rails.root
config = {}
namespace :tj do
  desc "Apply initial template."
  task :install do
    generator.instance_eval do
      config[:home_controller] = yes?("Generate home controller?")
      config[:scaffold] = yes?("Generate scaffold?")
      config[:migrate] = yes?("migrate database?")
      config[:bootstrap] = yes?("Install Twitter Boostrap to 'vendor/assets/' ?")
      Rake::Task["tj:install:home_controller"].invoke if config[:home_controller]
      Rake::Task["tj:install:scaffold"].invoke if config[:scaffold]
      Rake::Task["tj:install:bootstrap"].invoke if config[:bootstrap]
      Rake::Task["db:migrate"].invoke if config[:migrate]
    end
  end

  namespace :install do
    desc "Install Gems"
    task :gems do
      generator.instance_eval do
        if config[:create_devise_user] = yes?("Create user model for devise?")
          config[:user_model_name] = ask("What would you like the user model to be called? [user]")
          config[:user_model_name] = "user" if config[:user_model_name].blank?
        end
        ## User
        gem "devise"
        generate("devise:install")
        generate("devise:views")
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
        gem_group :test, :development do
          gem "rspec-rails"
          generate("rspec:install")
          gem "faker"
          gem "rubyzip"
        end
        puts "Don't forget to run `bundle install` and `rake tj:install`"
      end
    end

    desc "Generate home controller with default actions: index, about, contact"
    task :home_controller do
      generator.instance_eval do
        remove_file "public/index.html"
        generate(:controller, "home index about contact")
        route "root :to => 'home#index'"
      end
    end

    desc "Generate default scaffold"
    task :scaffold do
      generator.instance_eval do
        source = File.expand_path('../../templates', __FILE__)
        directory source, 'lib/templates'
        application <<-eos
      config.generators do |g|
            g.stylesheets false
          end
        eos
      end
    end

    desc "Install Bootstrap"
    task :bootstrap do
      generator.instance_eval do
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
    end
  end
end