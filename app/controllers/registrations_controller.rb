class RegistrationsController < Devise::RegistrationsController
  include Devise::Controllers::InternalHelpers
  before_filter :can_register?
  layout 'unregistered'

  respond_to :html, :js

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
    check_company_registration
    resource.consider_invitation_email = cookies[:invite_email]
    resource.skip_password_validation = true

    if resource.save
      set_flash_message :alert, :inactive_signed_up, :reason => resource.inactive_message.to_s if is_navigational_format?
      expire_session_data_after_sign_in!
      respond_with resource, :location => '/' do |format|
        format.html
        unless cookies[:kudo_key].blank?
          resource.comment_invitation_kudo cookies[:kudo_key]
          flash[:notice] = I18n.t('devise.registrations.sent_and_registered')
          sign_in :user, resource
        end
      end
    else
      if request.xhr?
        render 'create'
      else
        render_with_scope :new if request.format.html?
      end
    end
    clean_up_session_and_cookies
  end

  def update
    super
  end

  private

    def autofill_form
      resource.attributes = session[:user] if params[:autofill]
    end

    def check_company_registration
      resource.has_company = (params[:company] == "true")
    end

    def clean_up_session_and_cookies
      session[:user] = nil
      session[:authentication] = nil
      session['omniauth']      = nil
      cookies[:can_register]   = nil
      cookies[:response]       = nil
      cookies[:author_id]      = nil
    end




end