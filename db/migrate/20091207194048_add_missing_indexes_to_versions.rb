class AddMissingIndexesToVersions < ActiveRecord::Migration
  def self.up
    add_index :version, :package_id
    add_index :version, :maintainer_id
  end

  def self.down
    remove_index :version, :package_id
    remove_index :version, :maintainer_id
  end
end
