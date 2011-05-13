class RenameEmailConfirmedToConfirmed < ActiveRecord::Migration
  def self.up
    rename_column :merges, :email_confirmed, :confirmed
  end

  def self.down
    rename_column :merges, :confirmed, :email_confirmed
  end
end
