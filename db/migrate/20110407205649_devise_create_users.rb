class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
      t.confirmable
      t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      t.token_authenticatable
      t.timestamps
      t.date :birthday
      t.boolean :hide_birth_year
      t.string :first_name, :last_name, :middle_name, :honorific, :nickname, :gender,
               :streetadress, :address2, :city, :state_or_province, :postal_code, :country,
               :phone_number, :mobile_number, :status
    end
    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :confirmation_token,   :unique => true
    add_index :users, :unlock_token,         :unique => true
  end

  def self.down
    drop_table :users
  end
end