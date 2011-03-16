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

ActiveRecord::Schema.define(:version => 20110315153114) do

  create_table "author", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "author_identity", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "author_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "author_identity", ["author_id"], :name => "index_author_identity_on_author_id", :unique => true
  add_index "author_identity", ["user_id"], :name => "index_author_identity_on_user_id"

  create_table "enhanced_package_version", :id => false, :force => true do |t|
    t.integer "version_id",          :null => false
    t.integer "enhanced_package_id", :null => false
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
    t.integer  "package_users_count", :default => 0,   :null => false
    t.float    "score",               :default => 0.0
  end

  add_index "package", ["latest_version_id"], :name => "index_package_on_latest_version_id"
  add_index "package", ["name"], :name => "index_package_on_name"
  add_index "package", ["package_users_count"], :name => "index_package_on_package_users_count"
  add_index "package", ["score"], :name => "index_package_on_score"

  create_table "package_rating", :force => true do |t|
    t.integer  "package_id"
    t.integer  "user_id"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "aspect",     :limit => 25, :default => "overall", :null => false
  end

  add_index "package_rating", ["aspect"], :name => "index_package_rating_on_aspect"
  add_index "package_rating", ["package_id"], :name => "index_package_rating_on_package_id"
  add_index "package_rating", ["user_id"], :name => "index_package_rating_on_user_id"

  create_table "package_user", :force => true do |t|
    t.integer  "package_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     :default => true, :null => false
  end

  add_index "package_user", ["package_id", "user_id"], :name => "index_package_user_on_package_id_and_user_id", :unique => true

  create_table "required_package_version", :id => false, :force => true do |t|
    t.integer "version_id",          :null => false
    t.integer "required_package_id", :null => false
  end

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

  add_index "review", ["package_id"], :name => "index_review_on_package_id"
  add_index "review", ["user_id"], :name => "index_review_on_user_id"
  add_index "review", ["version_id"], :name => "index_review_on_version_id"

  create_table "review_comment", :force => true do |t|
    t.integer  "review_id",                :null => false
    t.integer  "user_id",                  :null => false
    t.string   "title",      :limit => 45, :null => false
    t.text     "comment",                  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "review_comment", ["review_id"], :name => "index_review_comment_on_review_id"
  add_index "review_comment", ["user_id"], :name => "index_review_comment_on_user_id"

  create_table "sitemap_setting", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "xml_location"
    t.string   "username"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "use_index"
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

  create_table "suggested_package_version", :id => false, :force => true do |t|
    t.integer "version_id",           :null => false
    t.integer "suggested_package_id", :null => false
  end

  create_table "tag", :force => true do |t|
    t.string   "name",                      :null => false
    t.string   "full_name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",        :limit => 25
    t.string   "version",     :limit => 10
  end

  add_index "tag", ["type"], :name => "index_tag_on_type"

  create_table "tagging", :force => true do |t|
    t.integer  "user_id"
    t.integer  "package_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tag_id"
  end

  add_index "tagging", ["user_id", "package_id", "tag_id"], :name => "index_tagging_on_user_id_and_package_id_and_tag_id"

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
    t.string   "cached_value"
  end

  create_table "user", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "activated_at"
    t.boolean  "remember",                           :default => false, :null => false
    t.string   "homepage"
    t.text     "profile"
    t.text     "profile_html"
    t.string   "single_access_token",                :default => "",    :null => false
    t.string   "role_name",           :limit => 40
    t.string   "perishable_token",    :limit => 40
    t.string   "persistence_token",   :limit => 128, :default => "",    :null => false
    t.integer  "login_count",                        :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.boolean  "tos"
  end

  add_index "user", ["last_request_at"], :name => "index_user_on_last_request_at"
  add_index "user", ["login"], :name => "index_user_on_login"
  add_index "user", ["persistence_token"], :name => "index_user_on_persistence_token"

  create_table "version", :force => true do |t|
    t.integer  "package_id"
    t.string   "name"
    t.string   "title"
    t.text     "description"
    t.text     "license"
    t.string   "version"
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
    t.text     "imports"
    t.text     "enhances"
    t.string   "priority"
    t.datetime "publicized_or_packaged"
    t.text     "version_changes"
  end

  add_index "version", ["maintainer_id"], :name => "index_version_on_maintainer_id"
  add_index "version", ["package_id"], :name => "index_version_on_package_id"

  create_table "weekly_digest", :force => true do |t|
    t.string   "param",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weekly_digest", ["param"], :name => "index_weekly_digest_on_param", :unique => true

end
