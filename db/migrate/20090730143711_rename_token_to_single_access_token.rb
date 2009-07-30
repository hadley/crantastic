class RenameTokenToSingleAccessToken < ActiveRecord::Migration
  def self.up
    rename_column :user, :token, :single_access_token
    change_column :user, :single_access_token, :string, :null => false, :default => ""
  end

  def self.down
    rename_column :user, :single_access_token, :token
    change_column :user, :token, :string, :null => true
  end
end
