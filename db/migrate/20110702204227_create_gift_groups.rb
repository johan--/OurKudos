class CreateGiftGroups < ActiveRecord::Migration
  def change
    create_table :gift_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
