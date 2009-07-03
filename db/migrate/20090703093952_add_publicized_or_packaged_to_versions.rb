class AddPublicizedOrPackagedToVersions < ActiveRecord::Migration
  def self.up
    add_column :version, :publicized_or_packaged, :datetime
  end

  def self.down
    remove_column :version, :publicized_or_packaged
  end
end
