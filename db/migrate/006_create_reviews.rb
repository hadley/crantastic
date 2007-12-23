class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :review do |t|
      t.integer :package_id
      t.integer :user_id

      t.integer :rating
      t.text :review
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :review
  end
end
