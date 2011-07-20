class CommentsController < ApplicationController

  def create
    @comment = @commentable.comments.build params[:comment]
    @comment.user = current_user

    if @comment.save
    else
    end
  end

  private

  def get_commentable
    @commentable = Kudo.find(params[:kudo_id]) if params[:kudo_id]

    raise ActiveRecord::RecordNotFound if @commentable.blank?
  end

end
