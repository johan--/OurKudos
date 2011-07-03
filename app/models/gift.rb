class Gift < ActiveRecord::Base
  belongs_to :merchant
  has_and_belongs_to_many :gift_groups

  delegate :name, :to => :gift_group, :prefix => true
  delegate :name, :to => :merchant, :prefix => true
  
end
