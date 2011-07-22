class Admin::SitesController < Admin::AdminController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html, :js
  
  def index
    @sites = Site.order :site_name
  end
  
  def new
    @site = Site.new
  end
  
  def ban
    selected_ids = params[:sites]
    
    selected_ids.each do |key, value|
      site = Site.find key.to_i
      value == 'true' ? site.ban! : site.unban!
    end

    redirect_to admin_sites_path, :notice => I18n.t(:selected_sites_were_updated)    

  end
  
  def create
    @site = Site.new params[:site]
    respond_with @site, :location => admin_sites_path do |format|
      format.html do 
        if @site.save
          redirect_to admin_sites_path, :notice => I18n.t(:your_site_has_been_saved)
        else
          render :action => :new
        end  
      end
    end
  end

  def show
    @site = Site.find params[:id]
    @keys = @site.api_keys.order :id
  end
  
  def update
    @site = Site.find params[:id]
    @keys = @site.api_keys.order(:id)
    if @site.update_attributes params[:site]
      redirect_to admin_site_path(@site), :notice => I18n.t(:site_has_been_updated)
    else  
      render :show
    end
  end
  
  def destroy
    @site = Site.find params[:id]
    if @site && @site.api_keys.destroy_all && @site.destroy
      redirect_to admin_sites_path, :notice => I18n.t(:site_removed_successfully)
    else
      redirect_to admin_sites_path, :notice => I18n.t(:there_was_problem_removing_site)
    end
  end
  
  
end
