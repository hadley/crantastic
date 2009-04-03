# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090402200300) do

  create_table "author", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "package", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
  end

  create_table "package_rating", :force => true do |t|
    t.integer  "package_id"
    t.integer  "user_id"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "package_rating", ["user_id"], :name => "index_package_rating_on_user_id"

  create_table "package_trigram", :force => true do |t|
    t.integer "package_id",                :null => false
    t.string  "tg",                        :null => false
    t.integer "score",      :default => 1, :null => false
  end

  add_index "package_trigram", ["package_id"], :name => "index_package_trigram_on_package_id"
  add_index "package_trigram", ["tg"], :name => "index_package_trigram_on_tg"

  create_table "review", :force => true do |t|
    t.integer  "package_id"
    t.integer  "user_id"
    t.integer  "rating"
    t.text     "review"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tagging", :force => true do |t|
    t.integer  "user_id"
    t.integer  "package_id"
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
  end

  create_table "version", :force => true do |t|
    t.integer  "package_id"
    t.string   "name"
    t.string   "title"
    t.string   "description"
    t.string   "license"
    t.string   "version"
    t.string   "requires"
    t.string   "depends"
    t.string   "suggests"
    t.string   "maintainer"
    t.string   "author"
    t.string   "url"
    t.date     "date"
    t.text     "readme"
    t.text     "changelog"
    t.text     "news"
    t.text     "diff"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "maintainer_id"
  end

end
