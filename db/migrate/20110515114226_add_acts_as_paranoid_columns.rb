class AddActsAsParanoidColumns < ActiveRecord::Migration
  def self.up
    add_column :users, :deleted_at, :datetime
    add_column :identities, :deleted_at, :datetime
  end

  def self.down
    remove_column :users, :deleted_at
    remove_column :identities, :deleted_at
  end
end
