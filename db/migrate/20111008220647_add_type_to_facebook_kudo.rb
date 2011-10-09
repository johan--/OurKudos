class AddTypeToFacebookKudo < ActiveRecord::Migration
  def change
    add_column :facebook_kudos, :post_type, :string
  end
end
