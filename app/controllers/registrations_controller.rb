class RegistrationsController < Devise::RegistrationsController
  include Devise::Controllers::InternalHelpers
  before_filter :can_register?
  layout 'unregistered'
  
  def new
    build_resource
    autofill_form
    @terms_of_service = Page.find_by_slug('terms-of-service').body
    render_with_scope :new 
  end

  def create
    resource = build_resource
    @terms_of_service = Page.find_by_slug('terms-of-service').body
    resource.authentications.build(session[:authentication]) if params[:autofill] && session[:authentication]
    resource.add_role

    resource.consider_invitation_email = cookies[:invite_email]
    if resource.save
      set_flash_message :alert, :inactive_signed_up, :reason => resource.inactive_message.to_s if is_navigational_format?
      expire_session_data_after_sign_in!
      respond_with resource, :location => '/'      
      session[:user] = nil
      session[:authentication] = nil
      session['omniauth']      = nil
      cookies[:can_register]   = nil
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