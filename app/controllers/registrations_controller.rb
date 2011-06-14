class RegistrationsController < Devise::RegistrationsController
  include Devise::Controllers::InternalHelpers
  layout 'unregistered'
  
  def new
    build_resource
    autofill_form
    render_with_scope :new 
  end

  def create
    resource = build_resource
    resource.authentications.build(session[:authentication]) if params[:autofill] && session[:authentication] 
    if resource.save
      set_flash_message :alert, :inactive_signed_up, :reason => resource.inactive_message.to_s if is_navigational_format?
      expire_session_data_after_sign_in!
      respond_with resource, :location => '/'      
      session[:user] = nil
      session[:authentication] = nil
      session['omniauth'] = nil
    else
      render_with_scope :new 
    end
  end

  def update
    super
  end

  private

    def autofill_form
      resource.attributes = session[:user] if params[:autofill]
    end
  
  
  
end