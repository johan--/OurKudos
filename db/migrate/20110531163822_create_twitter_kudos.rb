class CreateTwitterKudos < ActiveRecord::Migration
  def change
    create_table :twitter_kudos do |t|
      t.string :twitter_handle
      t.timestamps
    end
  end
end
