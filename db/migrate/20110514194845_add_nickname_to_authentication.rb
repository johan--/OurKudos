class AddNicknameToAuthentication < ActiveRecord::Migration
  def self.up
    add_column :authentications, :nickname, :string
  end

  def self.down
    remove_column :authentications, :nickname
  end
end
