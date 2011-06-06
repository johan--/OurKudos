# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110606093601) do

  create_table "api_keys", :force => true do |t|
    t.string   "key"
    t.date     "expires_at"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "roles",      :default => "none"
    t.string   "nickname"
  end

  create_table "confirmations", :force => true do |t|
    t.string   "key"
    t.boolean  "confirmed"
    t.integer  "confirmable_id"
    t.string   "confirmable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "confirmations", ["confirmable_id"], :name => "index_confirmations_on_confirmable_id"
  add_index "confirmations", ["confirmable_type"], :name => "index_confirmations_on_confirmable_type"
  add_index "confirmations", ["key"], :name => "index_confirmations_on_key"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "email_kudos", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "facebook_friends", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "name"
    t.string   "identifier"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "folders", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
  end

  add_index "folders", ["ancestry"], :name => "index_folders_on_ancestry"

  create_table "forbidden_passwords", :force => true do |t|
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "friend_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_contacted_at"
    t.integer  "contacts_count",    :default => 0
  end

  add_index "friendships", ["friend_id"], :name => "index_friendships_on_friend_id"
  add_index "friendships", ["user_id"], :name => "index_friendships_on_user_id"

  create_table "identities", :force => true do |t|
    t.integer  "user_id"
    t.string   "identity"
    t.string   "identity_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_primary",    :default => false
    t.datetime "deleted_at"
  end

  create_table "ips", :force => true do |t|
    t.string   "address"
    t.boolean  "blocked",         :default => false
    t.datetime "unlock_in",       :default => '1911-05-29 16:30:13'
    t.integer  "failed_attempts", :default => 0
    t.datetime "last_seen"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kudo_copies", :force => true do |t|
    t.integer  "recipient_id"
    t.integer  "folder_id"
    t.integer  "kudo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "temporary_recipient"
    t.integer  "kudoable_id"
    t.string   "kudoable_type"
  end

  add_index "kudo_copies", ["kudoable_id"], :name => "index_kudo_copies_on_kudoable_id"
  add_index "kudo_copies", ["kudoable_type"], :name => "index_kudo_copies_on_kudoable_type"

  create_table "kudos", :force => true do |t|
    t.integer  "author_id"
    t.integer  "member_kudo_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "facebook_sharing", :default => false
    t.boolean  "twitter_sharing",  :default => false
  end

  create_table "merges", :force => true do |t|
    t.integer  "merged_by"
    t.integer  "identity_id"
    t.integer  "merged_id"
    t.string   "merged_with_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.string   "code"
    t.string   "access_token"
    t.string   "refresh_token"
    t.datetime "access_token_expires_at"
    t.integer  "user_id"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["access_token"], :name => "index_permissions_on_access_token"
  add_index "permissions", ["code"], :name => "index_permissions_on_code"
  add_index "permissions", ["refresh_token"], :name => "index_permissions_on_refresh_token"

  create_table "roles", :force => true do |t|
    t.string   "name",       :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "sites", :force => true do |t|
    t.string   "site_name"
    t.string   "url"
    t.string   "protocol"
    t.text     "description"
    t.boolean  "blocked",            :default => false
    t.integer  "api_keys_count",     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "application_id"
    t.string   "application_secret"
  end

  add_index "sites", ["application_id"], :name => "index_sites_on_application_id"
  add_index "sites", ["application_secret"], :name => "index_sites_on_application_secret"

  create_table "twitter_kudos", :force => true do |t|
    t.string   "twitter_handle"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "birthday"
    t.boolean  "hide_birth_year"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.string   "honorific"
    t.string   "nickname"
    t.string   "gender"
    t.string   "streetadress"
    t.string   "address2"
    t.string   "city"
    t.string   "state_or_province"
    t.string   "postal_code"
    t.string   "country"
    t.string   "phone_number"
    t.string   "mobile_number"
    t.string   "status"
    t.boolean  "confirmed"
    t.datetime "deleted_at"
    t.string   "password_salt"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
