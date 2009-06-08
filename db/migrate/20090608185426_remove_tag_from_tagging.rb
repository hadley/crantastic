class RemoveTagFromTagging < ActiveRecord::Migration
  def self.up
    remove_column :tagging, :tag
  end

  def self.down
    add_column :tagging, :tag, :string
  end
end
