class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_user_time_zone

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to home_path, :alert => exception.message
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
      Kudo.allowed_tabs.include?(params[:kudos]) ?
          term = params[:kudos] :
          term = "newsfeed"
      @kudos = current_user.send("#{term}_kudos").page(params[:page]).per(10) rescue []

      @kudos = Kudo.public_kudos.limit(10)                        if term == 'newsfeed' && @kudos.blank?
      @kudos = @kudos.order(Kudo.sort_by_field params[:sort_by] ) if @kudos.respond_to?(:order) && @kudos.first.is_a?(Kudo)
      @kudos = @kudos.order(Kudo.sort_by_field params[:sort_by] ) if @kudos.respond_to?(:order) && @kudos.first.is_a?(KudoCopy)

      @kudos = Kudo.public_kudos(5) if @kudos.is_a?(Array) && @kudos.blank?
    end
  end

  def choose_layout
      user_signed_in? ? "registered" : "unregistered"
  end

  def request_from_kudo_email?
      params.keys.include?("kudo_id") && params.keys.include?("recipient") &&
          request.referer.blank?
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

  private
  def set_user_time_zone
    Time.zone = current_user.time_zone if current_user && current_user.time_zone.present?
  end

end
