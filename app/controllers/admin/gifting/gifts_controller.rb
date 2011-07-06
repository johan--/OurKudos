class Admin::Gifting::GiftsController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin'
  respond_to :html
  
  def index
    @gifts = Gift.all
  end
  
  def show
    @gift = Gift.find(params[:id])
  end

  def new
    @gift = Gift.new
  end

  def create
    @gift = Gift.new params[:gift]
    if @gift.save
      flash[:notice] = I18n.t(:gift_has_been_saved)
      redirect_to admin_gifting_gift_path(@gift)
    else
      render :new
    end
  end

  def edit
    @gift = Gift.find params[:id]
  end

  def update
    params[:gift][:gift_group_ids] ||= []
    @gift = Gift.find params[:id]
    if @gift.update_attributes(params[:gift])
      flash[:notice] = "Successfully updated gift"
      redirect_to admin_gifting_gift_path(@gift)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @gift = Gift.find params[:id]
    if @gift.destroy
      redirect_to(:back, :notice => I18n.t(:gift_has_been_deleted))
    else
      redirect_to(:back, :notice => I18n.t(:gift_has_not_been_deleted))
    end
  end

end
