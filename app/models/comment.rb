class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  validates :comment, :presence => true

  belongs_to :commentable, :polymorphic => true, :counter_cache => true
  belongs_to :user

  scope :for_user, ->(user) { where(:user_id => user.id)}

  validates_with CommentValidator
  after_save :send_moderation_notification, :if => :can_send_moderation_notification?
  after_save :update_kudo_updated_at_time


  def send_moderation_notification
    if commentable.system_kudos_recipients_cache.push(commentable.author_id).include?(user_id) == false
      emails = commentable.recipients_emails.compact.uniq
      emails = emails - [user.email]
      for email in emails do
        UserNotifier.delay.kudo_moderate self, email
      end
    end
    # whenever a comment is created, notify the original Kudo author unless commenter and original author are same
    UserNotifier.delay.kudo_moderate self, self.commentable.author.email unless self.commentable.author_id == user_id
  end

  def can_send_moderation_notification?
    !commentable.comments_moderation_enabled.blank?
  end

  def is_blocked_sender?
    self.commentable.blocked_commentators.include? user_id.to_i
  end

  def is_allowed_to_be_removed_by? user
    self.commentable.system_kudos_recipients_cache.include? user.id
  end

  def is_moderator?(user)
    commentable.author == user ||
      (!user.blank? && commentable.recipients_emails.include?(user.email))
  end

  def update_kudo_updated_at_time
    commentable.update_attribute("updated_at", Time.now)
  end
  class << self

    def allowed_actions
      %w(reject no_moderation no_commenting block_sender accept)
    end

    def reply_as_user_to_kudo user, kudo, comment
      create :user_id     => user.id,
             :commentable => kudo,
             :comment     => comment
    end

  end

end
