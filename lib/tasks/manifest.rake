namespace :heroku do
  desc "Populates the .gems manifest file, to be used with Heroku"
  task :gems => :environment do
    File.open(File.join(RAILS_ROOT, ".gems"), "w") do |f|
      Rails.configuration.gems.each do |dep|
        f.puts dep.send(:install_command)[1..-1].join(' ')
      end
    end
  end
end
