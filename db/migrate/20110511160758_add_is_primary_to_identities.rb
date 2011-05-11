class AddIsPrimaryToIdentities < ActiveRecord::Migration
  def self.up
    add_column :identities, :is_primary, :boolean, :default => false
  end

  def self.down
    remove_column :identities, :is_primary
  end
end
