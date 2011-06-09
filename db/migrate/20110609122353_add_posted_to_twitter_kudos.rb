class AddPostedToTwitterKudos < ActiveRecord::Migration
  def change
    add_column :twitter_kudos, :posted, :boolean, :default => false
  end
end
