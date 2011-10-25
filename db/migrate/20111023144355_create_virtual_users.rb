class CreateVirtualUsers < ActiveRecord::Migration
  def change
    create_table :virtual_users do |t|
      t.string :first_name
      t.string :last_name
      t.boolean :merged, :default => false

      t.timestamps
    end
  end
end
