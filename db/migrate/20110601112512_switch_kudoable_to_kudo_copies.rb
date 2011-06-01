class SwitchKudoableToKudoCopies < ActiveRecord::Migration
  def up
    remove_column :kudos, :kudoable_id
    remove_column :kudos, :kudoable_type
    add_column    :kudo_copies, :kudoable_id, :integer
    add_column    :kudo_copies, :kudoable_type, :string
    add_index     :kudo_copies, :kudoable_id
    add_index     :kudo_copies, :kudoable_type
  end

  def down
    add_column :kudos, :kudoable_id, :integer
    add_column :kudos, :kudoable_type, :string
    remove_column    :kudo_copies, :kudoable_id
    remove_column    :kudo_copies, :kudoable_type
    remove_index     :kudo_copies, :kudoable_id
    remove_index     :kudo_copies, :kudoable_typ
  end
end