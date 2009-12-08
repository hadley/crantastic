class AddVersionChangesToVersions < ActiveRecord::Migration
  def self.up
    add_column :version, :version_changes, :text
  end

  def self.down
    remove_column :version, :version_changes
  end
end
