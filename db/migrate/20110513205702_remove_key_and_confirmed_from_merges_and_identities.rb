class RemoveKeyAndConfirmedFromMergesAndIdentities < ActiveRecord::Migration
  def self.up
    remove_column :merges, :key
    remove_column :identities, :key
    remove_column :merges, :confirmed
    remove_column :identities, :confirmed
  end

  def self.down
    add_column :identities, :key, :string
    add_column :identities, :confirmed, :boolean, :default => false
    add_column :merges, :key, :string
    add_column :merges, :confirmed, :boolean, :default => false
  end
end
