class CreateReviewComments < ActiveRecord::Migration
  def self.up
    create_table :review_comment do |t|
      t.integer :review_id, :null => false
      t.integer :user_id, :null => false
      t.string :title, :null => false
      t.text :comment, :null => false

      t.timestamps
    end

    add_index :review_comment, :user_id
    add_index :review_comment, :review_id
  end

  def self.down
    drop_table :review_comment
  end
end
