class Admin::AttachmentsController < Admin::AdminController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  
  def index
    @attachment = Attachment.all
  end
  
  def show
    @attachment = Attachment.find(params[:id])
  end

  def new
    @attachment = Attachment.new
  end

  def create
    @attachment = Attachment.new params[:attachment]
    if @attachment.save
      flash[:notice] = I18n.t(:card_has_been_saved)
      redirect_to admin_attachment_path(@attachment)
    else
      render :new
    end
  end

  def edit
    @attachment = Attachment.find params[:id]
  end

  def update
    @attachment = Attachment.find params[:id]
    if @attachment.update_attributes(params[:attachment])
      flash[:notice] = "Successfully updated card"
      redirect_to admin_attachment_path(@attachment)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @attachment = Attachment.find params[:id]
    if @attachment.destroy
      redirect_to(admin_attachments_path, :notice => I18n.t(:card_has_been_deleted))
    else
      redirect_to(admin_attachments_path, :notice => I18n.t(:card_has_not_been_deleted))
    end
  end

end
