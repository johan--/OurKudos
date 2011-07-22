class Admin::KudoCategoriesController < Admin::AdminController
  before_filter :authenticate_user!
  load_and_authorize_resource

  respond_to :html

  def index
    @kudo_categories = KudoCategory.scoped.order("name ASC")
    @kudo_category   = KudoCategory.new
  end


  def create
    @kudo_categories = KudoCategory.scoped
    @kudo_category   = KudoCategory.new params[:kudo_category]
    if @kudo_category.save
      flash[:notice] = I18n.t(:kudo_category_has_been_been_created)
      respond_with @kudo_category, :location => admin_kudo_categories_path
    else
      render :index
    end
  end

  def edit
    @kudo_category = KudoCategory.find(params[:id]) 
  end

  def update
    @kudo_categories = KudoCategory.scoped
    if @kudo_category.update_attributes(params[:kudo_category])
      flash[:notice] = "Successfully updated Kudo Category"
      respond_with @kudo_category, :location => admin_kudo_categories_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    @kudo_category = KudoCategory.find params[:id]
    if @kudo_category.destroy
      redirect_to(:back, :notice => I18n.t(:kudo_category_has_been_deleted))
    else
      redirect_to(:back, :notice => I18n.t(:kudo_category_has_not_been_deleted))
    end
  end


end
