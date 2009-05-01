class CreatePackageRatings < ActiveRecord::Migration
  def self.up
    create_table :package_rating do |t|
      t.integer :package_id
      t.integer :user_id
      t.integer :rating

      t.timestamps
    end

    add_index :package_rating, :user_id
  end

  def self.down
    drop_table :package_rating
  end
end
