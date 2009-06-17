desc "Cron task, updates task views"
namespace :crantastic do
  task :taskviews => :environment do
    Crantastic::UpdateTaskViews.new.start
  end
end
