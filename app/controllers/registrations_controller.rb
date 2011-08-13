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
    if resource.save
      set_flash_message :alert, :inactive_signed_up, :reason => resource.inactive_message.to_s if is_navigational_format?
      expire_session_data_after_sign_in!
      session[:user] = nil
      session[:authentication] = nil
      session['omniauth']      = nil
      cookies[:can_register]   = nil
      respond_with resource, :location => '/' do |format|
        format.html
        format.js do
        resource.send_reply_kudo! params[:author_id] if request.xhr? && !params[:author_id].blank?
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




end