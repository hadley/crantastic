# This file will get executed once per hour.

desc "Cron task, updates package versions"
task :cron => :environment do
  begin
    CRAN::UpdatePackages.new.start(10) # Only update 10 packages per hour
  rescue OpenURI::HTTPError => e # 404
    req_status = e.io.status[0] # 3xx, 4xx, 5xx
    Log.log! "HTTP Error: #{req_status}"
  rescue SocketError # timeout, etc
    Log.log! "Socket error, check your connection"
  rescue URI::InvalidURIError => e
    puts e.to_s
  end
end
