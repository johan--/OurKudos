class AffiliateProgram < ActiveRecord::Base
  # ================
  # ==Associations==
  # ================
  has_many :merchants
  has_many :gift, :through => :merchants

  # ================
  # = Validations ==
  validates :name,  :presence => true, :uniqueness => true
  # ================
end
