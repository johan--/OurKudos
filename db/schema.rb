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

ActiveRecord::Schema.define(:version => 20110518151548) do

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

  create_table "identities", :force => true do |t|
    t.integer  "user_id"
    t.string   "identity"
    t.string   "identity_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_primary",    :default => false
    t.datetime "deleted_at"
  end

  create_table "merges", :force => true do |t|
    t.integer  "merged_by"
    t.integer  "identity_id"
    t.integer  "merged_id"
    t.string   "merged_with_email"
    t.string   "account_merged"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.boolean  "blocked",        :default => false
    t.integer  "api_keys_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",                    :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",                    :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
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
    t.datetime "unlock_in",                           :default => '1911-05-18 15:54:16'
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
