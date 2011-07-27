class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :image_file_name, :image_content_type
      t.integer :image_file_size, :user_id
      t.datetime :image_updated_at, :created_at
    end
  end
end
