namespace :gems do
  desc "Populates the .gems manifest file, to be used with Heroku"
  task :manifest => :environment do
    File.open(File.join(RAILS_ROOT, ".gems"), "w") do |f|
      Rails.configuration.gems.each do |dep|
        out = "#{dep.name}"
        out += " --source #{dep.source}" unless dep.source.blank?
        f.puts out
      end
    end
  end
end
