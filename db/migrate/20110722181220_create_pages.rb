class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title, :slug, :locale
      t.text :body
      t.timestamps
    end
  end
end
