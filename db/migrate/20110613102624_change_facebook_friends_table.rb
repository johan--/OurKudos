class ChangeFacebookFriendsTable < ActiveRecord::Migration
  def up
    add_column :facebook_friends, :facebook_id, :integer
    execute "ALTER TABLE facebook_friends ALTER COLUMN facebook_id TYPE bigint"
    FacebookFriend.all.each do |friend|
       friend.update_attribute :facebook_id, friend.identifier
    end
    sleep 1
    remove_column :facebook_friends, :identifier
  end

  def down
    # no reverse
  end
end
