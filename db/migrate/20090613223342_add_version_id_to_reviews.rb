class AddVersionIdToReviews < ActiveRecord::Migration
  def self.up
    add_column :review, :version_id, :integer
  end

  def self.down
    remove_column :review, :version_id
  end
end
