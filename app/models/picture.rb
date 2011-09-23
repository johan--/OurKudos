class Picture < ActiveRecord::Base
  belongs_to :user

  has_attached_file :image, :styles => {
      :large    => "640x480!",
      :medium   => '150x150!',
      :small    => "50x50#"
  }

  validates_attachment_presence :image
end
