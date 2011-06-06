class AddSocialSharingBooleanToKudos < ActiveRecord::Migration
  def change
    add_column :kudos, :facebook_sharing, :boolean, :default => false
    add_column :kudos, :twitter_sharing,  :boolean, :default => false
  end
end
