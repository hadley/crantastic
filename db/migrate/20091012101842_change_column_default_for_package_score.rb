class ChangeColumnDefaultForPackageScore < ActiveRecord::Migration
  def self.up
    change_column_default :package, :score, 0.0
  end

  def self.down
    change_column_default :package, :score, nil
  end
end
