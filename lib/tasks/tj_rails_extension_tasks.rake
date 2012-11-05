namespace :tj do
  desc "Apply initial template."
  task :install do
    location = File::join(File.dirname(__FILE__), "..", "templates", "init.rb")
    system "rake rails:template LOCATION=" + location
    system "bundle install"
    system "rake tj:bootstrap"
  end

  desc "Install Bootstrap"
  task :bootstrap do
    location = File::join(File.dirname(__FILE__), "..", "templates", "bootstrap.rb")
    system "rake rails:template LOCATION=" + location
  end
end