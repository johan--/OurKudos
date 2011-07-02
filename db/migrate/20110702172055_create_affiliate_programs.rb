class CreateAffiliatePrograms < ActiveRecord::Migration
  def change
    create_table :affiliate_programs do |t|
      t.string :name
      t.string :homepage

      t.timestamps
    end
  end
end
