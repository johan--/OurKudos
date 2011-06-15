class PasswordsController < Devise::PasswordsController
  prepend_before_filter :require_no_authentication
  include Devise::Controllers::InternalHelpers

  # GET /resource/password/new
  def new
    super
  end

  # POST /resource/password
  def create
    self.resource = User.get_identity_user_by(params[:user][:email]) || resource_class.send_reset_password_instructions(params[resource_name])
    if resource.errors.empty?
      set_flash_message(:notice, :send_instructions) if is_navigational_format?
      respond_with resource, :location => after_sending_reset_password_instructions_path_for(resource_name)
    else
      respond_with resource { render_with_scope :new }
    end
  end

  def edit
   super
  end


  def update
    self.resource = resource_class.reset_password_by_token(params[resource_name])

    if resource.errors.empty?
      set_flash_message(:notice, :updated) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with resource, :location => home_path
    else
      respond_with resource { render_with_scope :edit }
    end
  end

    protected

    def after_sending_reset_password_instructions_path_for(resource_name)
      new_session_path(resource_name)
    end


end