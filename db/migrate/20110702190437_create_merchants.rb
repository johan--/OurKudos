class CreateMerchants < ActiveRecord::Migration
  def change
    create_table :merchants do |t|
      t.string :name
      t.string :homepage
      t.string :affiliate_code
      t.text :description
      t.integer :affiliate_program_id

      t.timestamps
    end
  end
end
