class CreateEmailKudos < ActiveRecord::Migration
  def change
    create_table :email_kudos do |t|
      t.string :email
      t.timestamps
    end
  end
end
