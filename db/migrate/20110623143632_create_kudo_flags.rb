class CreateKudoFlags < ActiveRecord::Migration
  def change
    create_table :kudo_flags do |t|
      t.string :flag_reason
      t.integer :flagger_id, :kudo_copy_id
      t.boolean :flag_valid
      t.integer :recipients_count, :default => 0
      t.timestamps
    end
    add_index :kudo_flags, :flag_reason
    add_index :kudo_flags, :flagger_id
  end
end
