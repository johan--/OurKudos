class HomeController < ApplicationController
	before_filter :authenticate_user!, :except => [:index, :invite]
  before_filter :get_kudos , :only => [:home]
  layout :choose_layout


  def index
	  	redirect_to home_path if user_signed_in?
  end    
  
  def home
    @kudo   = Kudo.new
  end

  def invite
  end

  private

    def choose_layout
      user_signed_in? ? "registered" : "unregistered"
    end

    def get_kudos
      %w{received sent}.include?(params[:kudos]) ?
          term = params[:kudos] :
          term = "sent"
      @kudos = current_user.send "#{term}_kudos"
    end
end
