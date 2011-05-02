class AddRolesToAuthentication < ActiveRecord::Migration
  def self.up
    add_column :authentications, :roles, :string, :default => "none"
  end

  def self.down
    remove_column :authentications, :roles
  end
end
