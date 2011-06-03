class ChangeFacebookFriendsIdentifierToString < ActiveRecord::Migration
  def up
    change_column :facebook_friends, :identifier, :string
  end

  def down
    change_column :facebook_friends, :identifier, :integer, :limit => 6
  end
end
