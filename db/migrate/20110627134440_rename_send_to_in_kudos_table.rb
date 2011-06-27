class RenameSendToInKudosTable < ActiveRecord::Migration
  def up
    rename_column :kudos, :send_to, :to
  end

  def down
    rename_column :kudos, :to, :send_to
  end
end
