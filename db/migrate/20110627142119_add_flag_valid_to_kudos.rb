class AddFlagValidToKudos < ActiveRecord::Migration
  def change
    add_column :kudos, :has_been_improperly_flagged, :boolean
  end
end
