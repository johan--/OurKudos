class Attachment < ActiveRecord::Base
  has_attached_file :attachment, 
                    :styles => {:thumb => "128x145>", 
                                :standard => "260x200>"}
  validates_attachment_presence :attachment
  validates_attachment_size :attachment, :less_than => 5.megabytes
  validates :name, :uniqueness => true
  belongs_to :kudo
    
  def to_param
    "#{self.id}-#{self.name.underscore.gsub(" ",'-')}"
  end
end
