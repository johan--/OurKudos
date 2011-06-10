class HomeController < ApplicationController
	before_filter :authenticate_user!, :only => [:home]
  before_filter :get_kudos , :only => [:home]
  before_filter :check_invitation, :only => [:invite]
  layout :choose_layout


  def index
	  if user_signed_in?
      	redirect_to home_path
    else
      @kudos =  Kudo.public_kudos.order("id DESC").limit(5)
    end
  end    
  
  def home
    @kudo    = Kudo.new
  end

  def invite
  	render :layout => 'unregistered'
  end
  
  def about
  end
  
  def support
  end
  
  def contact
  end
  
  def privacy
  end

  private

    def choose_layout
      user_signed_in? ? "registered" : "unregistered"
    end

    def check_invitation
      @kudo = EmailKudo.find params[:kudo_id] rescue nil
      return true if !@kudo.blank? && @kudo.email == params[:email]

      redirect_to(:action => :index)
      false
    end
end
