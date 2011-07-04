class GiftGroup < ActiveRecord::Base
  # ================
  # = Validations ==
  validates :name,  :presence => true
  # ================
end
