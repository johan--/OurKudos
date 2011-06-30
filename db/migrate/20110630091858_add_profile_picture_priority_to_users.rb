class AddProfilePicturePriorityToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profile_picture_priority, :string,
                                                  :default => User.send(:default_profile_picture_types).to_yaml
  end
end
