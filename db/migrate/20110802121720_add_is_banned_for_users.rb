class AddIsBannedForUsers < ActiveRecord::Migration
  def up
    add_column :users, :is_banned, :boolean, :default => false
  end

  def down
    remove_column :users, :is_banned
  end
end
