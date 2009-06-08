class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tag do |t|
      t.string :name, :null => false
      t.string :full_name, :null => true
      t.text :description, :null => true
      t.boolean :task_view, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :tag
  end
end
