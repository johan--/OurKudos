class CommentsController < ApplicationController
  before_filter :get_commentable

  respond_to :js

  def new
    @comment = @commentable.comments.build
  end

  def create
    @comment = @commentable.comments.build params[:comment]
    @comment.user = current_user

    respond_with @comment do |format|
      format.js do
        render 'errors' unless @comment.save
      end
    end
  end

  private

  def get_commentable
    @commentable = Kudo.find(params[:kudo_id]) if params[:kudo_id]

    raise ActiveRecord::RecordNotFound if @commentable.blank?
  end

end
