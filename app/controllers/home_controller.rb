class HomeController < ApplicationController
	before_filter :authenticate_user!, :only => [:home]
  before_filter :check_if_recipient_valid, :only => [:home]
  before_filter :check_invitation, :only => [:invite]
  before_filter :check_searchterms, :only => [:home]
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

    if params[:searchterms].blank?
      get_kudos
    else
      search_kudos
    end
  end

  def invite
  	render :layout => 'unregistered'
  end

  def support
  	render :layout => 'unregistered'
  end


  private

    def check_invitation
      sign_out :user if user_signed_in?

      cookies[:can_register]   = true

      @kudo = EmailKudo.with_kudo_by_key(params[:kudo_id]).first rescue nil

      cookies[:invite_email]  = @kudo.email rescue nil

      @user = User.new
      @terms_of_service = Page.find_by_slug('terms-of-service').body

      return true if !@kudo.blank? && @kudo.viewable_by_recipient?(params[:email], params[:kudo_id])

      redirect_to root_path, :notice => I18n.t(:you_are_not_allowed_to_view_this_kudo)
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

    def check_searchterms
      params[:kudos] = "searchterms" if go_to_search_tab?
    end

    def search_kudos
        @kudos = Kudo.serchterms_kudos(params[:searchterms]).where(:share_scope => nil).limit(10)
    end

    def go_to_search_tab?
      (!params[:kudos].blank? && params[:kudos] != 'searchterms' && !params[:searchterms].blank?) ||
        (params[:kudos].blank? && !params[:searchterms].blank?)
    end



end
