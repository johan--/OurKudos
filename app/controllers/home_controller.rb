class HomeController < ApplicationController
	before_filter :authenticate_user!, :except => [:index]
  layout :choose_layout


  def index
	  	redirect_to home_path if user_signed_in?
  end    
  
  def home
    @kudo = Kudo.new
  end


  private

    def choose_layout
      user_signed_in? ? "registered" : "unregistered"
    end

  
end
