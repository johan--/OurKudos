class RemoveApiKeysFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :api_key
  end

  def self.down
    add_column :users, :api_key, :string
  end
end
