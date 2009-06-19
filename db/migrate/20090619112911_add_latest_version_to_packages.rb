class AddLatestVersionToPackages < ActiveRecord::Migration
  def self.up
    add_column :package, :latest_version_id, :integer
    add_index :package, :latest_version_id
    Package.all.each do |pkg|
      pkg.update_attribute(:latest_version_id, pkg.versions[0].id)
    end
  end

  def self.down
    remove_index :package, :latest_version_id
    remove_column :package, :latest_version_id
  end
end
