class AddArchivedKudosTable < ActiveRecord::Migration
  def up
    create_table "archived_kudos", :force => true do |t|
      t.integer  "author_id"
      t.text     "body"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "facebook_sharing", :default => false
      t.boolean  "twitter_sharing",  :default => false
      t.string   "share_scope"
      t.string   "to"
      t.integer  "kudo_category_id"
      t.boolean  "removed",          :default => false
      t.string   "flaggers",         :default => "--- []\n\n"
    end
  end

  def down
    drop_table :archived_kudos
  end
end
