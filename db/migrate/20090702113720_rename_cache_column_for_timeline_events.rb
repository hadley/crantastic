class RenameCacheColumnForTimelineEvents < ActiveRecord::Migration
  def self.up
    rename_column :timeline_event, :cached_rating, :cached_value
    change_column :timeline_event, :cached_value, :string
  end

  def self.down
    rename_column :timeline_event, :cached_value, :cached_rating
    change_column :timeline_event, :cached_rating, :integer
  end
end
