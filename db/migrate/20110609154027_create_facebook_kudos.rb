class CreateFacebookKudos < ActiveRecord::Migration
  def change
    create_table :facebook_kudos do |t|
      t.string :identifier, :response, :name
      t.boolean :posted
      t.timestamps
    end
  end
end
