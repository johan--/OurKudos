class Admin::SitesController < ApplicationController
  
  respond_to :html, :js
  
  def index
    @sites = Site.all
  end
  
  def new
    @site = Site.new
  end
  
  def create
    @site = Site.new params[:site]
    respond_with @site, :location => admin_sites_path do |format|
      format.html do 
        if @site.save
          redirect_to admin_sites_path, :notice => t(:your_site_has_been_saved)
        else
          render :action => :new
        end  
      end
    end
  end
  
  
end
