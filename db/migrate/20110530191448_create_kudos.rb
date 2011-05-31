class CreateKudos < ActiveRecord::Migration
  def change
    create_table :kudos do |t|
      t.integer :author_id, :kudoable_id, :member_kudo_id
      t.string  :subject,   :kudoable_type
      t.text    :body
      t.timestamps
    end
  end
end
