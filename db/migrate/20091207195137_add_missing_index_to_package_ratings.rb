class AddMissingIndexToPackageRatings < ActiveRecord::Migration
  def self.up
    add_index :package_rating, :package_id
  end

  def self.down
    remove_index :package_rating, :package_id
  end
end
