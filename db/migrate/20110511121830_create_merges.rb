class CreateMerges < ActiveRecord::Migration
  def self.up
    create_table :merges do |t|
      t.integer :merged_by
      t.string :merged_with_email, :key
      t.boolean :email_confirmed, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :merges
  end
end
