class Admin::Gifting::AffiliateProgramsController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin'
  respond_to :html
  
  def index
    @affiliate_program = AffiliateProgram.new
    @affiliate_programs = AffiliateProgram.all
  end

  def new
  end

  def create
    @affiliate_program = AffiliateProgram.new params[:affiliate_program]
    if @affiliate_program.save
      flash[:notice] = I18n.t(:affiliate_program_has_been_saved)
      respond_with @kudo_category, :location => admin_gifting_affiliate_programs_path
    else
      render :index
    end
  end

  
end
