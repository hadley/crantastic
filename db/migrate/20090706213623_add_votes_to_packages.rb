class AddVotesToPackages < ActiveRecord::Migration
  def self.up
    # Counter cache
    add_column :package, :package_votes_count, :integer, :default => 0, :null => false
    add_index :package, :package_votes_count
  end

  def self.down
    remove_index :package, :package_votes_count
    remove_column :package, :package_votes_count
  end
end
