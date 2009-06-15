class AddAspectToPackageRatings < ActiveRecord::Migration
  def self.up
    add_column :package_rating, :aspect, :string, :null => false, :default => "overall", :limit => 25
    add_index :package_rating, :aspect

    # Migrate existing rows
    PackageRating.all.each do |pr|
      pr.update_attribute(:aspect, "overall") if pr.aspect.blank?
    end
  end

  def self.down
    remove_index :package_rating, :aspect
    remove_column :package_rating, :aspect
  end
end
