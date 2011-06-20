class RegistrationsController < Devise::RegistrationsController
  before_filter :sign_out_user, :only => [:new]
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
    resource.add_role
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

    def sign_out_user
      sign_out :user
    end
  


end