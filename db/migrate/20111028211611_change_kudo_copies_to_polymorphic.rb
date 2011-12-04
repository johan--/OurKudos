class ChangeKudoCopiesToPolymorphic < ActiveRecord::Migration
  def up
    add_column :kudo_copies, :recipient_type, :string
    KudoCopy.update_all(:recipient_type => 'User')
  end

  def down
    remove_column :kudo_copies, :recipient_type
  end
end
