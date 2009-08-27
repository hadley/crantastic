namespace :crantastic do

  desc "Cron task, updates package versions and task views"
  task :cron => :environment do
    begin
      # Update packages every hour
      Crantastic::UpdatePackages.new.start

      # Update task views four times per day
      Crantastic::UpdateTaskViews.new.start if [0,6,12,18].include?(Time.now.hour)

    rescue OpenURI::HTTPError => e
      req_status = e.io.status[0] # 3xx, 4xx, 5xx
      Log.log_and_report! "HTTP Error: #{req_status}"
    rescue SocketError # timeout, etc
      Log.log_and_report! "Socket error, check your connection"
    rescue URI::InvalidURIError => e
      Log.log_and_report! "Invalid URI Error"
    rescue Exception => e
      Log.log_and_report! e
    end
  end

  desc "Update all packages"
  task :update_packages => :environment do
    Crantastic::UpdatePackages.new.start
  end

  desc "Update all task views"
  task :update_taskviews => :environment do
    Crantastic::UpdateTaskViews.new.start
  end

  desc "Tweet daily summaries"
  task :tweet => :environment do
    Crantastic::Tweet.new.start
  end

  desc "Create weekly digest for the current week (should run each sunday)"
  task :create_weekly_digest => :environment do
    Crantastic::CreateWeeklyDigest.new.start
  end

  desc "Displays the 20 last log entries"
  task :lastlog => :environment do
    Log.all(:limit => 20, :order => "created_at DESC").reverse.each do |entry|
      puts entry
    end
  end

end
