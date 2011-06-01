class AddTemporaryRecipientToKudoCopies < ActiveRecord::Migration
  def change
    add_column :kudo_copies, :temporary_recipieint, :string
  end

end