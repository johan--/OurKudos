class AddDisplayIdentityToIdentities < ActiveRecord::Migration
  def change
    add_column :identities, :display_identity, :boolean, :default => false
  end
end
