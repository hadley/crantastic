class CreateVersions < ActiveRecord::Migration
  def self.up
    create_table :version do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :version
  end
end
