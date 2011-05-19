class Admin::ForbiddenPasswordsController <  Admin::AdminController
  
  respond_to :html
  before_filter :get_passwords

  def index    
    @forbidden_password = ForbiddenPassword.new
  end

  def create
    @forbidden_password = ForbiddenPassword.new params[:forbidden_password]
    if @forbidden_password.save
      flash[:notice] = I18n.t(:forbidden_password_has_been_added)
      respond_with @forbidden_password, :location => admin_forbidden_passwords_path
    else
      render :index
    end
  end


  def destroy
    @forbidden_password = ForbiddenPassword.find params[:id]
    if @forbidden_password.destroy
      redirect_to(:back, :notice => I18n.t(:forbidden_password_has_been_deleted))
    else
      redirect_to(:back, :notice => I18n.t(:forbidden_password_has_not_been_deleted))
    end
  end


  private

    def get_passwords
      @passwords = ForbiddenPassword.page(params[:page]).per(params[:per_page])
    end

end
