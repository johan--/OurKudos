class AddOldPasswordSaltAndOldEncryptedPasswordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :old_password_salt,  :string
    add_column :users, :old_encrypted_password, :string
  end
end
