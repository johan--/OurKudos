class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  include OurKudos::Controllers::IpVerification

  def after_sign_in_path_for resource
    (session[:"user.return_to"].nil?) ?
        "/" : session[:"user.return_to"].to_s
  end

  def get_kudos
    %w{received sent}.include?(params[:kudos]) ?
          term = params[:kudos] :
          term = "sent"
    @kudos = current_user.send("#{term}_kudos").order("id DESC")
  end

  def choose_layout
      user_signed_in? ? "registered" : "unregistered"
  end

  def request_from_kudo_email?
      params.keys.include?("kudo_id") && params.keys.include?("recipient")
  end


end
