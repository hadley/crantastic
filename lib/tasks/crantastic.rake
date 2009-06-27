namespace :crantastic do

  desc "Update all packages"
  task :update_packages => :environment do
    Crantastic::UpdatePackages.new.start
  end

  desc "Update all task views"
  task :update_taskviews => :environment do
    Crantastic::UpdateTaskViews.new.start
  end

  desc "Displays the 20 last log entries"
  task :lastlog => :environment do
    Log.all(:limit => 20, :order => "created_at DESC").reverse.each do |entry|
      puts entry
    end
  end

end
