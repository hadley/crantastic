# The 'cron' task gets executed once per hour by Heroku.

desc "Cron task, updates package versions"
task :cron => :environment do
  begin
    Crantastic::UpdatePackages.new.start(10) # Only update 10 packages per hour
  rescue OpenURI::HTTPError => e # 404
    req_status = e.io.status[0] # 3xx, 4xx, 5xx
    Log.log! "HTTP Error: #{req_status}"
  rescue SocketError # timeout, etc
    Log.log! "Socket error, check your connection"
  rescue URI::InvalidURIError => e
    Log.log! e.to_s
  rescue Exception => e
    Log.log! e.to_s
  end
end

# A copy of the cron task, under the crantastic name space
desc "Cron task, updates package versions"
namespace :crantastic do
  task :cron => :environment do
    Crantastic::UpdatePackages.new.start(10)
  end
end
