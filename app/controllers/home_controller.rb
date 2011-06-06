class HomeController < ApplicationController
	before_filter :authenticate_user!, :except => [:index, :invite, :about]
  before_filter :get_kudos , :only => [:home]
  layout :choose_layout


  def index
	  	redirect_to home_path if user_signed_in?
  end    
  
  def home
    @kudo   = Kudo.new
  end

  def invite
  	render :layout => 'unregistered'
  end
  
  def about
  	render :layout => 'unregistered'
  end

  private

    def choose_layout
      user_signed_in? ? "registered" : "unregistered"
    end


end
