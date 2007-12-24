class VersionAuthor < ActiveRecord::Migration
  def self.up
    add_column :version, :author_id, :integer
  end

  def self.down
    delete_column :version, :author_id
  end
end
