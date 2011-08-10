class MerchantKudo < ActiveRecord::Base

  has_one :kudo, :class_name => "KudoCopy", :as => :kudoable
  after_save :deliver!

  def deliver!

  end


end