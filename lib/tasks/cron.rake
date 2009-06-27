# The 'cron' task gets executed once per hour by Heroku.

desc "Cron task, updates package versions"
task :cron => :environment do
  begin
    # Update packages every hour
    Crantastic::UpdatePackages.new.start

    # Update task views four times per day
    Crantastic::UpdateTaskViews.new.start if [0,6,12,18].include?(Time.now.hour)

    Log.log!("Cron task finished.")
  rescue OpenURI::HTTPError => e
    req_status = e.io.status[0] # 3xx, 4xx, 5xx
    Log.log_and_report! "HTTP Error: #{req_status}"
  rescue SocketError # timeout, etc
    Log.log_and_report! "Socket error, check your connection"
  rescue URI::InvalidURIError => e
    Log.log_and_report! e.to_s
  rescue Exception => e
    Log.log_and_report! e.to_s
  end
end
