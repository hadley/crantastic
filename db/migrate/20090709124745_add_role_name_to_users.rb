class AddRoleNameToUsers < ActiveRecord::Migration
  def self.up
    add_column :user, :role_name, :string, :limit => 40
  end

  def self.down
    remove_column :user, :role_name
  end
end
