class ChangeUserFields < ActiveRecord::Migration
  def self.up
    # To support the stronger crypt algorithms in authlogic
    change_column :user, :crypted_password, :string, :limit => 255
    change_column :user, :salt, :string, :limit => 255

    rename_column :user, :salt, :password_salt

    remove_column :user, :remember_token
    remove_column :user, :remember_token_expires_at
    remove_column :user, :activation_code
  end

  def self.down
    rename_column :user, :password_salt, :salt

    change_column :user, :crypted_password, :string, :limit => 40
    change_column :user, :salt, :string, :limit => 40

    add_column :user, :remember_token, :string
    add_column :user, :remember_token_expires_at, :datetime
    add_column :user, :activation_code, :string
  end
end
