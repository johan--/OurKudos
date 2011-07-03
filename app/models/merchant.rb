class Merchant < ActiveRecord::Base
  belongs_to :affiliate_program
  has_many :gifts
end
