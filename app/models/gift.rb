class Gift < ActiveRecord::Base
  belongs_to :merchant
  has_and_belongs_to_many :gift_groups

  has_attached_file :image, :styles => {:thumb => "128x145>", :standard => "300x300>"}
  delegate :name, :to => :gift_group, :prefix => true
  delegate :name, :to => :merchant, :prefix => true
  
end
