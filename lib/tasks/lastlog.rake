desc "Displays the 10 last log entries"
task :lastlog => :environment do
  Log.all(:limit => 10, :order => "created_at DESC").each do |entry|
    puts entry
  end
end
