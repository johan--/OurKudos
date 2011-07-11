class Merchant < ActiveRecord::Base
  # ================
  # ==Associations==
  belongs_to :affiliate_program
  has_many :gifts
  # ================

  # ================
  # = Validations ==
  validates :name,  :presence => true, :uniqueness => true
  # ================

  # ================
  # ==== Scopes ====
  default_scope order('name')
  # ================
end
