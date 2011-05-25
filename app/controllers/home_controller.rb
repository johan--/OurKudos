class HomeController < ApplicationController
	layout 'main'
	before_filter :authenticate_user!, :except => [:index]
  
  def index
			redirect_to home_path if user_signed_in?
  end    
  
  def home
  
  end
  
end
