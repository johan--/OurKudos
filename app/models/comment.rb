class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  validates :comment, :presence => true

  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  scope :for_user, ->(user) { where(:user_id => user.id)}

  validates_with CommentValidator
  after_save :send_moderation_notification, :if => :can_send_moderation_notification?


  def send_moderation_notification
    UserNotifier.delay.kudo_moderate self
  end

  def can_send_moderation_notification?
    !commentable.comments_moderation_enabled.blank?
  end

  def is_blocked_sender?
    self.commentable.blocked_commentators.include? user_id.to_i
  end

  def is_allowed_to_be_removed_by? user
    self.commentable.recipients_ids.include? user.id
  end

  class << self

    def allowed_actions
      %w(reject no_moderation no_commenting block_sender)
    end

  end

end