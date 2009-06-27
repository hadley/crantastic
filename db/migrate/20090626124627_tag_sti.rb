class TagSti < ActiveRecord::Migration
  # Refactor to STI for tags/task views
  def self.up
    add_column :tag, :type, :string, :length => 25

    Tag.all(:conditions => {:task_view => true}).each do |t|
      t.update_attribute(:type, "TaskView")
    end
    remove_column :tag, :task_view

    add_index :tag, :type
  end

  def self.down
    remove_column :tag, :type
    add_column :tag, :task_view, :boolean, :default => false
  end
end
