class AddActivation < ActiveRecord::Migration
  def self.up
    add_column :user, :activation_code, :string, :limit => 40
    add_column :user, :activated_at, :datetime
  end

  def self.down
    delete_column :user, :activation_code
    delete_column :user, :activated_at
  end
end
