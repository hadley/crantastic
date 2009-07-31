class AddActiveBooleanToTaggingsAndPackageUsers < ActiveRecord::Migration
  def self.up
    add_column :tagging, :active, :boolean, :default => true, :null => false
    add_column :package_user, :active, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :tagging, :active
    remove_column :package_user, :active
  end
end
