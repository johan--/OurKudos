class ConvertIdentityToPolymorphic < ActiveRecord::Migration
  def up
    rename_column :identities, :user_id, :identifiable_id
    add_column :identities, :identifiable_type, :string
    Identity.update_all(:identifiable_type => 'User')
  end

  def down
    rename_column :identities, :identifiable_id, :user_id
    remove_column :identities, :identifiable_type
  end
end
