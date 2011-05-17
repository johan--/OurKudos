class AddUnlockInToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :unlock_in, :datetime
  end

  def self.down
    remove_column :users, :unlock_in
  end
end
