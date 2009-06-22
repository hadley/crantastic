class AddCachedRatingToTimelineEvent < ActiveRecord::Migration
  def self.up
    # The ratings can change so we must cache the values
    add_column :timeline_event, :cached_rating, :integer, :null => true
    TimelineEvent.all(:conditions => "event_type = 'new_package_rating'").each do |e|
      e.update_attribute(:cached_rating, e.subject.rating)
    end
  end

  def self.down
    remove_column :timeline_event, :cached_rating
  end
end
