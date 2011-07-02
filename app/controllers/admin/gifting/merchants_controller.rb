class Admin::Gifting::MerchantsController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin'
  respond_to :html
  
  def index
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

  def destroy
  end
  
end
