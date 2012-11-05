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