class RemoveIpLockingFieldsFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :unlock_in
    remove_column :users, :failed_attempts
    remove_column :users, :locked_at
    remove_column :users, :unlock_token
  end

  def self.down
    add_column :users, :unlock_in,      :datetime
    add_column :users, :failed_attempts,:integer
    add_column :users, :locked_at,      :datetime
    add_column :users, :unlock_token,   :string
  end
end
