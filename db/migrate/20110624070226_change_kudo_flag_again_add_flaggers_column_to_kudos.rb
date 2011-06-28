class ChangeKudoFlagAgainAddFlaggersColumnToKudos < ActiveRecord::Migration
  def up
    remove_column :kudo_flags, :flaggable_id
    remove_column :kudo_flags, :flaggable_type
    add_column :kudo_flags, :kudo_id, :integer
    add_index  :kudo_flags, :kudo_id
    add_column :kudos, :flaggers, :string, :default => [].to_yaml
  end

  def down
    add_column :kudo_flags, :flaggable_id,   :integer
    add_column :kudo_flags, :flaggable_type, :string
    remove_column :kudo_flags, :kudo_id
    remove_index  :kudo_flags, :kudo_id
    remove_column :kudos, :flaggers
  end
end
