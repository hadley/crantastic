class CreateWeeklyDigests < ActiveRecord::Migration
  def self.up
    create_table :weekly_digest do |t|
      t.string :param, :null => false

      t.timestamps
    end

    add_index :weekly_digest, :param, :unique => true
  end

  def self.down
    drop_table :weekly_digest
  end
end
