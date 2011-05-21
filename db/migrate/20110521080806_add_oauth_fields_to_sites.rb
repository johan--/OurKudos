class AddOauthFieldsToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :application_id,     :string
    add_column :sites, :application_secret, :string
    add_index  :sites, :application_id
    add_index  :sites, :application_secret
  end

  def self.down
    remove_column :sites, :application_id
    remove_column :sites, :application_secret
    remove_index  :sites, :application_id
    remove_index  :sites, :application_secret
  end
end
