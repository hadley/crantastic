class AddVersionToTags < ActiveRecord::Migration
  def self.up
    add_column :tag, :version, :string, :limit => 10
  end

  def self.down
    remove_column :tag, :version
  end
end
