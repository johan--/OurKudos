class Admin::Gifting::AffiliateProgramsController < Admin::AdminController
  before_filter :authenticate_user!
  #layout 'admin'
  respond_to :html
  
  def index
    @affiliate_program = AffiliateProgram.new
    @affiliate_programs = AffiliateProgram.all
  end

  def create
   @affiliate_programs = AffiliateProgram.all
    @affiliate_program = AffiliateProgram.new params[:affiliate_program]
    if @affiliate_program.save
      flash[:notice] = I18n.t(:affiliate_program_has_been_saved)
      respond_with @gift_group, :location => admin_gifting_affiliate_programs_path
    else
      render :index
    end
  end

  def destroy
    @affiliate_program = AffiliateProgram.find params[:id]
    if @affiliate_program.destroy
      redirect_to(:back, :notice => I18n.t(:affiliate_program_has_been_deleted))
    else
      redirect_to(:back, :notice => I18n.t(:affiliate_program_has_not_been_deleted))
    end
  end
  
end

