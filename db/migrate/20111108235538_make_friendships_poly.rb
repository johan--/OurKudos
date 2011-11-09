class MakeFriendshipsPoly < ActiveRecord::Migration
  def up
    rename_column :friendships, :friend_id, :friendable_id
    add_column :friendships, :friendable_type, :string
    Friendship.update_all(:friendable_type => 'User')
  end

  def down
    rename_column :friendships, :friendable_id, :friend_id
    remove_column :friendships, :friendable_type
  end
end
