class AddAttachmentIdToKudo < ActiveRecord::Migration
  def change
    add_column :kudos, :attachment_id, :integer
  end
end
