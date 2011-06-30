class ChangeDefaultProfileTypeOrderToText < ActiveRecord::Migration
  def up
    change_column :users, :profile_picture_priority, :text
  end

  def down
    change_column :users, :profile_picture_priority, :string
  end
end
