namespace :cache do
  task :maintainers do
    require RAILS_ROOT + '/config/environment'
    
    blank = Version.find :all, :conditions => "maintainer_id IS NULL"
    blank.each &:cache_maintainer!
  end
end