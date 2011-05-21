class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.string :code, :access_token, :refresh_token
      t.datetime :access_token_expires_at
      t.integer :user_id
      t.integer :site_id
      t.timestamps
    end
    add_index :permissions, :code
    add_index :permissions, :access_token
    add_index :permissions, :refresh_token
  end

  def self.down
    drop_table :permissions
  end
end
