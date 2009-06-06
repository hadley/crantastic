class RemoveMaintainerFromVersions < ActiveRecord::Migration
  def self.up
    remove_column :version, :maintainer
  end

  def self.down
    add_column :version, :maintainer, :string
  end
end
