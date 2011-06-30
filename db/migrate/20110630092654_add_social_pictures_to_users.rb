class AddSocialPicturesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :social_picture_fb, :string
    add_column :users, :social_picture_tw, :string
  end
end
