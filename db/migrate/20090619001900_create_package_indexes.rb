class CreatePackageIndexes < ActiveRecord::Migration
  def self.up
    add_index :package, :name
  end

  def self.down
    remove_index :package, :name
  end
end
