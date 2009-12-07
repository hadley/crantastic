class AddMissingIndexesToReviews < ActiveRecord::Migration
  def self.up
    add_index :review, :package_id
    add_index :review, :version_id
    add_index :review, :user_id
  end

  def self.down
    remove_index :review, :package_id
    remove_index :review, :version_id
    remove_index :review, :user_id
  end
end
