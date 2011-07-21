class CommentsModerationsController < ApplicationController
  before_filter :authenticate_user!,
                :get_commentable_and_comment,
                :get_subaction


  def new
  end


  private

    def get_commentable_and_comment
      @comment     = current_user.comments.find params[:id] rescue nil
      @commentable = @comment.commentable if @comment
    end

    def get_subaction
     if !@commentable.blank? && Comment.allowed_actions.include?(params[:subaction])
      case params[:subaction]
        when "reject"
          @comment.destroy
          redirect_to home_path, :notice => I18n.t(:comment_has_been_rejected)
        when "no_moderation"
          @commentable.disable_moderation!
          redirect_to home_path, :notice => I18n.t(:moderation_has_been_disabled)
        when "no_commenting"
          @commentable.disable_commenting!
          redirect_to home_path, :notice => I18n.t(:commenting_has_been_disabled)
        when 'block_sender'
          @commentable.block_commentator! @comment.user
          redirect_to home_path, :notice => I18n.t(:commenting_has_been_disabled_for_that_user)
      end
     else
       render_404
     end
    end


end



