class AddAuthorIdToKudoCopies < ActiveRecord::Migration
  def change
    add_column :kudo_copies, :author_id, :integer
    add_index :kudo_copies, :author_id
  end
end
