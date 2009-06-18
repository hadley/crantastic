class CreateTimelineEvents < ActiveRecord::Migration
  def self.up
    create_table :timeline_event do |t|
      t.string   :event_type, :subject_type,  :actor_type,  :secondary_subject_type
      t.integer               :subject_id,    :actor_id,    :secondary_subject_id
      t.timestamps
    end

    add_index :timeline_event, [:subject_type, :subject_id,
                                :actor_type, :actor_id,
                                :secondary_subject_type, :secondary_subject_id]
  end

  def self.down
    drop_table :timeline_event
  end
end
