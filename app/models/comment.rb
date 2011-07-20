class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  validates :comment, :presence => true

  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  scope :for_user, ->(user) { where(:user_id => user.id)}

end
