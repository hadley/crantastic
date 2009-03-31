ActiveRecord::Schema.define(:version => 0) do
  create_table :packages, :force => true do |t|
    t.string :name
  end

  create_table :package_trigrams, :force => true do |t|
    t.integer :package_id
    t.string :tg
    t.integer :score
  end
end
