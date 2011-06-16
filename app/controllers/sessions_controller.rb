class SessionsController < Devise::SessionsController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  before_filter :verify_ip, :only => [:create]
  include Devise::Controllers::InternalHelpers 
	layout 'unregistered'
	
  def new
    super
  end

  def create
    resource = Identity.find_for_authentication(params[:user][:email]).user rescue nil
    ip_check_for(resource, params[:user][:password])     if resource
    devise_sign_in  unless resource
  end

  def destroy
   super
  end

  private

    def devise_sign_in
      resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
      set_flash_message(:notice, :signed_in) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with resource, :location => redirect_location(resource_name, resource)
    end

end



