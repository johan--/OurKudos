class AddRemovedToKudos < ActiveRecord::Migration
  def change
    add_column :kudos, :removed, :boolean, :default => false
  end
end
