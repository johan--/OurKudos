class AttachmentsController < ApplicationController
layout :choose_layout

  def show
    @attachment = Attachment.find(params[:id])
    respond_to do |format|
      format.html {render 'show', :layout => false}
      format.js {render 'attachment', :layout => false}
    end
  end

end
