class AddTosToUsers < ActiveRecord::Migration
  def self.up
    add_column :user, :tos, :boolean
  end

  def self.down
    remove_column :user, :tos
  end
end
