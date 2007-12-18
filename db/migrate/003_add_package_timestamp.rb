class AddPackageTimestamp < ActiveRecord::Migration
  def self.up
    add_column :package, :created_at, :datetime
  end

  def self.down
    remove_column :package, :created_at
  end
end
