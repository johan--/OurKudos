class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name, :limit => 50
      t.timestamps
    end

    create_table :roles_users, :id => false do |t|
      t.references :role, :user
    end
    add_index :roles_users, :user_id
    add_index :roles_users, :role_id
  end

  def self.down
    drop_table :roles
    drop_table :roles_users
  end
end
