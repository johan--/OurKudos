class AddTemporaryRecipientToKudoCopies < ActiveRecord::Migration
  def change
    add_column :kudo_copies, :temporary_recipient, :string
  end

end