namespace :crantastic do
  desc "Update all package versions"
  task :update_all_packages => :environment do
    Crantastic::UpdatePackages.new.start
  end
end
