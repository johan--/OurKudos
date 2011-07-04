class Gift < ActiveRecord::Base
  # ================
  # ==Associations==
  belongs_to :merchant
  has_and_belongs_to_many :gift_groups
  has_attached_file :image, :styles => {:thumb => "128x145>", :standard => "300x300>"}
  # ================

  # ================
  # == Delegators ==
  delegate :name, :to => :gift_group, :prefix => true
  delegate :name, :to => :merchant, :prefix => true
  # ================

  # ================
  # = Validations ==
  validates :name,    :presence => true
  validates :link,    :presence => true
  validates :price,   :numericality => {:greater_than => 0} 
  # ================
end
