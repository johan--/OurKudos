class Attachment < ActiveRecord::Base
  has_attached_file :attachment, 
                    :styles => {:thumb => "128x145>", 
                                :standard => "260x200>"}
  validates_attachment_presence :attachment
  validates_attachment_size :attachment, :less_than => 5.megabytes
  validates :name, :uniqueness => true
  has_many :kudos

  def to_param
    "#{self.id}-#{self.name.underscore.gsub('.','').gsub(" ",'-')}"
  end

  def file_path
    "#{Rails.root}/public/system/attachments/#{id}/original/#{attachment_file_name}"
  end
  def image_path
    "http://#{site_root}/system/attachments/#{id}/original/#{attachment_file_name}"
  end

  def kudo_link
    "http://#{site_root}/cards/#{self.id}"
  end

  def site_root
    return 'localhost:3000' if Rails.env.development?
    return 'rkudos.com' if Rails.env.staging?
    return 'ourkudos.com' if Rails.env.production?
    return 'ourkudos.com' if Rails.env.test?
  end
end
