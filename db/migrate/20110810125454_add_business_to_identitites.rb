class AddBusinessToIdentitites < ActiveRecord::Migration
  def change
    add_column :identities, :is_company, :boolean, :default => false
  end
end
