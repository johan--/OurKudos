class AddServerResponseToTwitterKudos < ActiveRecord::Migration
  def change
    add_column :twitter_kudos, :response, :string
  end
end
