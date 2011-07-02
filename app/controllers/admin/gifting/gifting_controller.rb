class Admin::Gifting::GiftingController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin'
  
  def index
  end


  
end
