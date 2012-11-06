namespace :tj do
  desc "Apply initial template."
  task :install do
    location = File::join(File.dirname(__FILE__), "..", "templates", "init.rb")
    system "rake rails:template LOCATION=" + location
    system "bundle install"
    Rake::Task["tj:install:bootstrap"].invoke
  end

  namespace :install do
    desc "Install Bootstrap"
    task :bootstrap do
      location = File::join(File.dirname(__FILE__), "..", "templates", "bootstrap.rb")
      system "rake rails:template LOCATION=" + location
    end
  end
end