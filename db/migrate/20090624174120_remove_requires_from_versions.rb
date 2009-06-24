class RemoveRequiresFromVersions < ActiveRecord::Migration
  def self.up
    remove_column :version, :requires
  end

  def self.down
    add_column :version, :requires, :string
  end
end
