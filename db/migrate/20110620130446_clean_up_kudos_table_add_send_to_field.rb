class CleanUpKudosTableAddSendToField < ActiveRecord::Migration
  def up
    add_column :kudos, :send_to, :string
    remove_column :kudos, :member_kudo_id
    remove_column :kudos, :subject
  end

  def down
    remove_column :kudos, :send_to
    add_column :kudos, :member_kudo_id, :string
    add_column :kudos, :subject, :string
  end
end
