class HomeController < ApplicationController
	before_filter :authenticate_user!, :only => [:home]
  before_filter :get_kudos , :only => [:home]
  layout :choose_layout


  def index
	  if user_signed_in?
      	redirect_to home_path
    else
      @kudos =  Kudo.public_kudos.limit(5).reverse
    end
  end    
  
  def home
    @kudo   = Kudo.new
  end

  def invite
  	render :layout => 'unregistered'
  end
  
  def about
  end
  
  def support
  end

  private

    def choose_layout
      user_signed_in? ? "registered" : "unregistered"
    end


end
