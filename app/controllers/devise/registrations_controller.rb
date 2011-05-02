class Devise::RegistrationsController < ApplicationController
  include Devise::Controllers::InternalHelpers
  
  def new
    resource = build_resource
    resource.apply_omniauth(session[:omniauth]) unless params[:fields].blank?
    render_with_scope :new 
  end

  def create
    params[:fields] = params[:fields].split(",") if params[:fields]
    build_resource
    resource.apply_omniauth(session[:omniauth]) unless params[:fields].blank?
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => redirect_location(resource_name, resource)
      else
        set_flash_message :notice, :inactive_signed_up, :reason => resource.inactive_message.to_s if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => '/'
      end
    else
      render_with_scope :new 
    end
  end

  def update
  end
end