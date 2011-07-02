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
  
  
end
