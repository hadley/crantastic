class CreateTaggings < ActiveRecord::Migration
  def self.up
    create_table :tagging do |t|
      t.integer :user_id
      t.integer :package_id
      t.string :tag

      t.timestamps
    end
  end

  def self.down
    drop_table :tagging
  end
end
