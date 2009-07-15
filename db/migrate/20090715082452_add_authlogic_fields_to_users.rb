class AddAuthlogicFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :user, :persistence_token, :string,
                      :limit => 128,
                      :default => "",
                      :null => false

    add_column :user, :login_count, :integer, :default => 0, :null => false

    add_column :user, :last_request_at, :datetime
    add_column :user, :last_login_at, :datetime
    add_column :user, :current_login_at, :datetime

    add_column :user, :last_login_ip, :string
    add_column :user, :current_login_ip, :string

    add_index :user, :login
    add_index :user, :persistence_token
    add_index :user, :last_request_at
  end

  def self.down
    remove_column :user, :persistence_token

    remove_column :user, :login_count

    remove_column :user, :last_request_at
    remove_column :user, :last_login_at
    remove_column :user, :current_login_at

    remove_column :user, :last_login_ip
    remove_column :user, :current_login_ip

    remove_index :user, :login
    remove_index :user, :persistence_token
    remove_index :user, :last_request_at
  end
end
