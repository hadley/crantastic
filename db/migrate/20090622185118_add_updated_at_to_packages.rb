class AddUpdatedAtToPackages < ActiveRecord::Migration
  def self.up
    add_column :package, :updated_at, :datetime
  end

  def self.down
    remove_column :package, :updated_at
  end
end
