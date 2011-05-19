class CreateForbiddenPasswords < ActiveRecord::Migration
  def self.up
    create_table :forbidden_passwords do |t|
      t.string :password
      t.timestamps
    end
  end

  def self.down
    drop_table :forbidden_passwords
  end
end
