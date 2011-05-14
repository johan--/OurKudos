class CreateConfirmations < ActiveRecord::Migration
  def self.up
    create_table :confirmations do |t|
      t.string :key
      t.boolean :confirmed
      t.references :confirmable, :polymorphic => true
      t.timestamps
    end
     add_index :confirmations, :confirmable_type
     add_index :confirmations, :confirmable_id
     add_index :confirmations, :key
  end

  def self.down
    drop_table :confirmations
  end
end
