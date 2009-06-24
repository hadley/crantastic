class AddImportsToVersions < ActiveRecord::Migration
  def self.up
    add_column :version, :imports, :string
  end

  def self.down
    remove_column :version, :imports
  end
end
