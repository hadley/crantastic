class AddTokenToUsers < ActiveRecord::Migration
  def self.up
    add_column :user, :token, :string, :limit => 40
  end

  def self.down
    remove_column :user, :token
  end
end
