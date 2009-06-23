class AddRememberToUsers < ActiveRecord::Migration
  def self.up
    add_column :user, :remember, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :user, :remember
  end
end
