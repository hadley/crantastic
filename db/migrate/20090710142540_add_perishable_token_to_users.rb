class AddPerishableTokenToUsers < ActiveRecord::Migration
  def self.up
    add_column :user, :perishable_token, :string, :limit => 40
  end

  def self.down
    remove_column :user, :perishable_token
  end
end
