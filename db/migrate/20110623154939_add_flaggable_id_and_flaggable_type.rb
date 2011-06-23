class AddFlaggableIdAndFlaggableType < ActiveRecord::Migration
  def up
    add_column :kudo_flags, :flaggable_id,   :integer
    add_column :kudo_flags, :flaggable_type, :string
    remove_column :kudo_flags, :kudo_copy_id
  end

  def down
    remove_column :kudo_flags, :flaggable_id
    remove_column :kudo_flags, :flaggable_type
    add_column :kudo_flags, :kudo_copy_id, :integer
  end
end
