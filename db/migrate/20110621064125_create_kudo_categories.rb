class CreateKudoCategories < ActiveRecord::Migration
  def change
    create_table :kudo_categories do |t|
      t.string :name
      t.timestamps
    end
    add_column :kudos, :kudo_category_id, :integer
    add_index :kudos, :kudo_category_id
  end
end
