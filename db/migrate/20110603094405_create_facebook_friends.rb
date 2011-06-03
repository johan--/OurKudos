class CreateFacebookFriends < ActiveRecord::Migration
  def change
    create_table :facebook_friends do |t|
      t.string :first_name, :last_name, :name
      t.integer :identifier, :limit => 10
      t.integer :user_id
      t.timestamps
    end
  end
end
