class CreateVirtualMerges < ActiveRecord::Migration
  def change
    create_table :virtual_merges do |t|
      t.integer :merged_by
      t.integer :merged_id
      t.integer :identity_id

      t.timestamps
    end
  end
end
