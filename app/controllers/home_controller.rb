class HomeController < ApplicationController
	before_filter :authenticate_user!, :except => [:index]
  
  def index
	  if user_signed_in?
	  	redirect_to home_path 
	  else
	  	render :layout => 'unregistered'
	  end
  end    
  
  def home
  	render :layout => 'registered'
  end
  
end
