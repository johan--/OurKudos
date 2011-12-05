class AddGiftingToKudos < ActiveRecord::Migration
  def change
    add_column :kudos, :gifting, :boolean, :default => false
  end
end
