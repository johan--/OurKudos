class SessionsController < Devise::SessionsController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  include Devise::Controllers::InternalHelpers 

  def new
    super
  end

  def create
    resource = warden.authenticate
    if resource.blank?
      redirect_to :back
      set_flash_message(:alert, :invalid) if is_navigational_format?
    elsif resource && resource.is_confirmed?     
      set_flash_message(:notice, :signed_in) if is_navigational_format?          
      respond_with resource, :location => redirect_location(resource_name, resource)
    else
      set_flash_message :notice, :inactive_signed_in, :reason => resource.inactive_message.to_s if is_navigational_format?
      sign_out resource_name
      redirect_to root_path, :notice => I18n.t('devise.sessions.user.inactive_signed_in')
    end
  end

  def destroy
   super
  end

end


