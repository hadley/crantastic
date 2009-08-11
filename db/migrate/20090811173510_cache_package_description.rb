class CachePackageDescription < ActiveRecord::Migration
  def self.up
    Package.all(:conditions => { :description => nil }).each do |p|
      p.update_attribute(:description, p.latest_version.description)
    end
  end

  def self.down
  end
end
