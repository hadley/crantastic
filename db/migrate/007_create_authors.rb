class CreateAuthors < ActiveRecord::Migration
  def self.up
    create_table :author do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :author
  end
end
