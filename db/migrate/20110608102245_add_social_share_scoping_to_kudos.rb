class AddSocialShareScopingToKudos < ActiveRecord::Migration
  def change
    add_column :kudos, :share_scope, :string
    add_column :kudo_copies, :share_scope, :string
  end
end
