class RemoveRatingFromReviews < ActiveRecord::Migration
  def self.up
    # I don't try to convert the old ratings since there was some confusion
    # if it was 1 or 5 that was the top of the rating scale.
    remove_column :review, :rating
  end

  def self.down
    add_column :review, :rating, :integer
  end
end
