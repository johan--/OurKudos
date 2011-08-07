class CreateMessagingPreferences < ActiveRecord::Migration
  def change
    create_table :messaging_preferences do |t|
      t.integer :user_id
      t.boolean :system_kudo_email, :default => true

      t.timestamps
    end
  end
end
