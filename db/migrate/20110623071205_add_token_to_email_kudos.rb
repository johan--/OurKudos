class AddTokenToEmailKudos < ActiveRecord::Migration
  def change
    add_column :email_kudos, :key, :string
  end
end
