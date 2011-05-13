class AddKeyFieldsToIdentity < ActiveRecord::Migration
  def self.up
    add_column :identities, :key, :string
    add_column :identities, :confirmed, :boolean, :default => false
  end

  def self.down
    remove_column :identities, :key
    remove_column :identities, :confirmed
  end
end
