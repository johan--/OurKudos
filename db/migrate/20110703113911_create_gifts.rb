class CreateGifts < ActiveRecord::Migration
  def change
    create_table :gifts do |t|
      t.string :name
      t.text :description
      t.float :price
      t.string :link
      t.boolean :active
      t.integer :merchant_id
      t.string :affiliate_code

      t.timestamps
    end
    create_table :gift_groups_gifts, :id => false do |t|
      t.integer :gift_id
      t.integer :gift_group_id
    end
  end
end
