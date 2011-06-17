class HomeController < ApplicationController
	before_filter :authenticate_user!, :only => [:home]
  before_filter :get_kudos, :check_if_recipient_valid, :only => [:home]
  before_filter :check_invitation, :only => [:invite]
  layout :choose_layout

  def index
	  if user_signed_in?
      	redirect_to home_path
    else
      flash.keep(:alert) unless flash[:alert].blank?
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

    def check_invitation
      sign_out :user if user_signed_in?
      @kudo = EmailKudo.find params[:kudo_id] rescue nil
      return true if !@kudo.blank? && @kudo.email == params[:email]
      false
    end

    def check_if_recipient_valid
      session['user.return_to'] = request.url if request_from_kudo_email?

       if request_from_kudo_email? && user_signed_in?
         if params[:recipient] != current_user.email
          sign_out(:user)
          redirect_to new_user_session_path, :alert => I18n.t(:please_sign_in_to_display_this_message)
          return false
         else
          session['user.return_to'] = nil
          return true
         end
       end

    end



end
