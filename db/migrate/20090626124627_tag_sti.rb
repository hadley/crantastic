class TagSti < ActiveRecord::Migration
  # Refactor to STI for tags/task views
  def self.up
    add_column :tag, :type, :string, :length => 25

    Tag.task_views.each { |t| t.update_attribute(:type, "TaskView") }
    remove_column :tag, :task_view

    add_index :tag, :type
  end

  def self.down
    remove_column :tag, :type
    add_column :tag, :task_view, :boolean, :default => false
  end
end
