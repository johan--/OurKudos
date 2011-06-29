class AddProfilePictureToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profile_picture_file_name,    :string
    add_column :users, :profile_picture_type,         :string
  end

end
