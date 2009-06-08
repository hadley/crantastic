class AddTagIdToTaggings < ActiveRecord::Migration
  def self.up
    add_column :tagging, :tag_id, :integer

    add_index :tagging, [:user_id, :package_id, :tag_id]
  end

  def self.down
    remove_column :tagging, :tag_id

    remove_index :tagging, [:user_id, :package_id, :tag_id]
  end
end
