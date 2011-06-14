class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  include OurKudos::Controllers::IpVerification



  def get_kudos
    %w{received sent}.include?(params[:kudos]) ?
          term = params[:kudos] :
          term = "sent"
    @kudos = current_user.send("#{term}_kudos").order("id DESC")
  end

  def choose_layout
      user_signed_in? ? "registered" : "unregistered"
  end


end
