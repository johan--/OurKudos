class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :facebook_icon, :twitter_icon

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  include OurKudos::Controllers::IpVerification

  def after_sign_in_path_for resource
    (session[:"user.return_to"].nil?) ?
        "/" : session[:"user.return_to"].to_s
  end

  def get_kudos
    %w{received sent newsfeed}.include?(params[:kudos]) ?
          term = params[:kudos] :
          term = "newsfeed"
    @kudos = current_user.send("#{term}_kudos")

    @kudos = @kudos.order("kudos.id DESC") if @kudos.respond_to?(:order) && @kudos.first.is_a?(Kudo)
    @kudos = @kudos.order("kudo_copies.id DESC") if @kudos.respond_to?(:order) && @kudos.first.is_a?(KudoCopy)
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

  def facebook_icon
    '<img src =\'/assets/facebook_icon.png\' />'.html_safe
  end

  def twitter_icon
    '<img src =\'/assets/twitter_icon.png\'  />'.html_safe
  end





end
