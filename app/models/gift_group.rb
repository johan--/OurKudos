class GiftGroup < ActiveRecord::Base
  has_and_belongs_to_many :gifts
  # ================
  # = Validations ==
  validates :name,  :presence => true
  # ================
end
