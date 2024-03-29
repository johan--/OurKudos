class CommentsModerationsController < ApplicationController

  layout "registered"
  before_filter :get_commentable_and_comment, :check_user



  def new
    get_subaction
  end

  def check_user

      email = params[:address]

      session['user.return_to'] = new_comments_moderation_url(:subaction => params[:subaction], :id => @comment.id)  rescue nil

      unless @comment.blank?
        unless @comment.is_moderator?(current_user)
          sign_out :user
          redirect_to new_user_session_path(:user => {:email => email}), :notice => t(:please_sign_in_as, :email => email)
        end
      else
        sign_out :user
        redirect_to root_path(:user => {:email => email}), :notice => t(:comment_has_been_removed)
      end
  end



  private

    def get_commentable_and_comment
      @comment     = Comment.find params[:id] rescue nil
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
        when 'accept'
          redirect_to home_path, :notice => I18n.t(:comment_has_been_accepted)
      end
     end
    end

    def go_home
      redirect_to home_path, :notice => t(:comment_has_been_removed)
    end


end



