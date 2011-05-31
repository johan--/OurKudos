class CreateKudoCopies < ActiveRecord::Migration
  def change
    create_table :kudo_copies do |t|
      t.integer :recipient_id, :folder_id, :kudo_id
      t.timestamps
    end
  end
end
