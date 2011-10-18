class AddTweetTypeToTwitterKudos < ActiveRecord::Migration
  def change
    add_column :twitter_kudos, :tweet_type, :string
  end
end
