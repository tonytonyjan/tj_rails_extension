require 'faker'
namespace :faker do
  desc "create some fake posts"
  task :posts => :environment do
    print "How many fake post do you want: "
    num = $stdin.gets.to_i
    num.times{
      Post.create(title: Faker::Name.title, content: Faker::Lorem.paragraph)
    }
    puts "#{num} created."
  end
end