class AddScoreToPackages < ActiveRecord::Migration
  def self.up
    add_column :package, :score, :real
    add_index  :package, :score
    Package.all.each { |pkg| pkg.update_attribute(:score, pkg.calculate_score) }
  end

  def self.down
    remove_column :package, :score
  end
end
