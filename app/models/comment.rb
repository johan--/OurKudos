class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  validates :comment, :presence => true

  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  scope :for_user, ->(user) { where(:user_id => user.id)}

  after_save :send_moderation_notification, :if => :can_send_moderation_notification?


  def send_moderation_notification
    UserNotifier.delay.kudo_moderate self
  end

  def can_send_moderation_notification?
    !commentable.comments_moderation_enabled.blank?
  end

end