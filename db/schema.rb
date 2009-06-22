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

ActiveRecord::Schema.define(:version => 20090622185118) do

  create_table "author", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log", :force => true do |t|
    t.string   "message",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "package", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.integer  "latest_version_id"
    t.datetime "updated_at"
  end

  add_index "package", ["latest_version_id"], :name => "index_package_on_latest_version_id"
  add_index "package", ["name"], :name => "index_package_on_name"

  create_table "package_rating", :force => true do |t|
    t.integer  "package_id"
    t.integer  "user_id"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "aspect",     :limit => 25, :default => "overall", :null => false
  end

  add_index "package_rating", ["aspect"], :name => "index_package_rating_on_aspect"
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
    t.text     "review"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version_id"
    t.integer  "cached_rating"
  end

  create_table "schema_info", :id => false, :force => true do |t|
    t.integer "version"
  end

  create_table "sitemap_setting", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "xml_location"
    t.string   "username"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sitemap_static_link", :force => true do |t|
    t.string   "url"
    t.string   "name"
    t.float    "priority"
    t.string   "frequency"
    t.string   "section"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sitemap_widget", :force => true do |t|
    t.string   "widget_model"
    t.string   "index_named_route"
    t.string   "frequency_index"
    t.string   "frequency_show"
    t.float    "priority"
    t.string   "custom_finder"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tag", :force => true do |t|
    t.string   "name",                           :null => false
    t.string   "full_name"
    t.text     "description"
    t.boolean  "task_view",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tagging", :force => true do |t|
    t.integer  "user_id"
    t.integer  "package_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tag_id"
  end

  add_index "tagging", ["package_id", "tag_id", "user_id"], :name => "index_tagging_on_user_id_and_package_id_and_tag_id"

  create_table "timeline_event", :force => true do |t|
    t.string   "event_type"
    t.string   "subject_type"
    t.string   "actor_type"
    t.string   "secondary_subject_type"
    t.integer  "subject_id"
    t.integer  "actor_id"
    t.integer  "secondary_subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cached_rating"
  end

  add_index "timeline_event", ["actor_id", "actor_type", "secondary_subject_id", "secondary_subject_type", "subject_id", "subject_type"], :name => "index_timeline_event_on_subject_type_and_subject_id_and_actor_t"

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
    t.text     "description"
    t.text     "license"
    t.string   "version"
    t.string   "requires"
    t.text     "depends"
    t.text     "suggests"
    t.text     "author"
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
