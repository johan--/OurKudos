class AddImageToGifts < ActiveRecord::Migration
  def change
    add_column :gifts, :image_file_name,    :string
    add_column :gifts, :image_content_type, :string
    add_column :gifts, :image_file_size,    :integer
    add_column :gifts, :image_updated_at,   :datetime
    
  end
end
