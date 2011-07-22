class Admin::IdentitiesController <  Admin::AdminController
  before_filter :get_user
  load_and_authorize_resource

  def new
    @identity = @user.identities.new
  end
  
  def create
    @identity = @user.identities.build params[:identity]
    if @identity.save
      redirect_to admin_user_path(@user), :notice => I18n.t(:identity_created)
    else
      render :new
    end
  end

   def edit
    @identity = @user.identities.find params[:id]
  end

  def update
    @identity = @user.identities.find params[:id]
    if @identity.update_attributes params[:identity]
      redirect_to admin_user_path(@user), :notice => I18n.t(:identity_updated)
    else
      render :edit
    end
  end

  def destroy
    @identity = @user.identities.find params[:id]
    if @identity.destroy
      redirect_to admin_user_path(@user), :notice => I18n.t(:identity_removed)
    else
      redirect_to admin_user_path(@user), :notice => I18n.t(:identity_not_removed)
    end
  end

  private

    def get_user
      @user = User.find params[:user_id]
    end

end
