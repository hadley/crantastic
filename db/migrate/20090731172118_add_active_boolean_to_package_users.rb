class AddActiveBooleanToPackageUsers < ActiveRecord::Migration
  def self.up
    add_column :package_user, :active, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :package_user, :active
  end
end
