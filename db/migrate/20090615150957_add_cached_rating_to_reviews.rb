class AddCachedRatingToReviews < ActiveRecord::Migration
  def self.up
    add_column :review, :cached_rating, :integer
  end

  def self.down
    remove_column :review, :cached_rating
  end
end
