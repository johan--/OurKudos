class CreateKudoFlagActions < ActiveRecord::Migration
  def change
    create_table :kudo_flag_actions do |t|
      t.integer :kudo_flag_id
      t.integer :admin_user_id
      t.string :action_taken

      t.timestamps
    end
  end
end
