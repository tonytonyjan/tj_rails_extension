namespace :tj do
  desc "Apply initial template."
  task :install do
    location = File::join(File.dirname(__FILE__), "..", "templates", "init.rb")
    system("rake rails:template LOCATION=" + location)
    #task("rails:template", "LOCATION="+location).invoke
  end
end