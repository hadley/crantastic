# This file will get executed once per hour.

desc "Cron task, updates package versions"
task :cron => :environment do
  CRAN::UpdatePackages.new.start(10) # Only update 10 packages per hour
end
