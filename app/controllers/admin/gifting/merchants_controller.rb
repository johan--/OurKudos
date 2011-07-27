class Admin::Gifting::MerchantsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource
  respond_to :html
  
  def index
    @merchants = Merchant.scoped #contrary to all 'scoped' runs query only when needed
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def new
    @merchant = Merchant.new
  end

  def create
    @merchant = Merchant.new params[:merchant]
    if @merchant.save
      flash[:notice] = I18n.t(:merchant_has_been_saved)
      redirect_to admin_gifting_merchant_path(@merchant)
    else
      render :new
    end
  end

  def edit
    @merchant = Merchant.find params[:id]
  end

  def update
    @merchant = Merchant.find params[:id]
    if @merchant.update_attributes(params[:merchant])
      flash[:notice] = "Successfully updated merchant"
      respond_with @merchant, :location => admin_gifting_merchants_path
    else
      render :action => 'edit'
    end
  end
  

  def destroy
    @merchant = Merchant.find params[:id]
    if @merchant.destroy
      redirect_to(admin_gifting_merchants_path, :notice => I18n.t(:merchant_has_been_deleted))
    else
      redirect_to(admin_gifting_merchants_path, :notice => I18n.t(:merchant_has_not_been_deleted))
    end
  end
  
end
