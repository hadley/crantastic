class AddEnhancesAndPriorityToVersions < ActiveRecord::Migration
  def self.up
    add_column :version, :enhances, :text
    add_column :version, :priority, :string
    change_column :version, :imports, :text
  end

  def self.down
    remove_column :version, :enhances
    remove_column :version, :priority
    change_column :version, :imports, :string
  end
end
