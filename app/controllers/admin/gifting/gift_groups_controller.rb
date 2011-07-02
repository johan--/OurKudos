class Admin::Gifting::GiftGroupsController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin'
  respond_to :html
  
  def index
    @gift_group = GiftGroup.new
    @gift_groups = GiftGroup.all
  end

  def create
    @gift_group = GiftGroup.new params[:gift_group]
    if @gift_group.save
      flash[:notice] = I18n.t(:gift_group_has_been_saved)
      respond_with @gift_group, :location => admin_gifting_gift_groups_path
    else
      render :index
    end
  end
 
  def destroy
    @gift_group =GiftGroup.find params[:id]
    if @gift_group.destroy
      redirect_to(:back, :notice => I18n.t(:gift_group_has_been_deleted))
    else
      redirect_to(:back, :notice => I18n.t(:gift_group_has_not_been_deleted))
    end
  end
  
  
end
