class ExtendFriendshipsWithContactDateAndContactCount < ActiveRecord::Migration
  def up
    add_column :friendships, :last_contacted_at, :datetime
    add_column :friendships, :contacts_count, :integer, :default => 0
    add_index :friendships,  :friend_id
    add_index :friendships,  :user_id
  end

  def down
    remove_column :friendships, :last_contacted_at
    remove_column :friendships, :contacts_count
    remove_index :friendships,  :friend_id
    remove_index :friendships,  :user_id
  end
end