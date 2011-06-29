class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :facebook_icon, :twitter_icon

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  include OurKudos::Controllers::IpVerification

  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404.html", :status => "404 Not Found" }
      format.xml  { render :nothing => true, :status => "404 Not Found" }
      format.json { render :text => "{}", :status => "404 Not Found" }
      end
    true
  end

  def after_sign_in_path_for resource
    (session[:"user.return_to"].nil?) ?
        home_path : session[:"user.return_to"].to_s
  end

  def get_kudos
    if user_signed_in?
      %w{received sent newsfeed}.include?(params[:kudos]) ?
          term = params[:kudos] :
          term = "newsfeed"
      @kudos = current_user.send("#{term}_kudos")

      @kudos = @kudos.order("kudos.id DESC")       if @kudos.respond_to?(:order) && @kudos.first.is_a?(Kudo)
      @kudos = @kudos.order("kudo_copies.id DESC") if @kudos.respond_to?(:order) && @kudos.first.is_a?(KudoCopy)
    end
  end

  def choose_layout
      user_signed_in? ? "registered" : "unregistered"
  end

  def request_from_kudo_email?
      params.keys.include?("kudo_id") && params.keys.include?("recipient")
  end

  def save_email_for_pass_recovery
      email = params.recursive_find_by_key("email")
      session['user.email_for_password_recovery'] = email if email && email =~ RegularExpressions.email
  end

  def clean_email_for_pass_recovery
      session['user.email_for_password_recovery'] = nil
  end

  def can_register?
    return true if cookies[:can_register] == "true"
    render_404  if SETTINGS[:sign_up_disabled] == 'yes'
    true
  end


end
