class RemoveDoubleTimelineEventsForPackageReleases < ActiveRecord::Migration
  def self.up
    # We don't want to list both the new_version and new_package events for new
    # packages, so we delete these from the db. New records will be handled by
    # the Version observer.
    events = TimelineEvent.all
    events.enum_with_index.map do |e, i|
      nxt = events[i+1]
      TimelineEvent.delete(e) if e.event_type == "new_version" &&
                                 nxt.event_type == "new_package" &&
                                 nxt.secondary_subject == e.secondary_subject
    end
  end

  def self.down
  end
end
