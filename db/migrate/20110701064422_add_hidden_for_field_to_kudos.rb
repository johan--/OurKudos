class AddHiddenForFieldToKudos < ActiveRecord::Migration
  def change
    add_column :kudos, :hidden_for, :string, :default => [].to_yaml
  end
end
