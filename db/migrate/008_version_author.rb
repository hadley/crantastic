class VersionAuthor < ActiveRecord::Migration
  def self.up
    add_column :version, :maintainer_id, :integer
  end

  def self.down
    delete_column :version, :maintainer_id
  end
end
