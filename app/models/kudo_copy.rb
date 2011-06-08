class KudoCopy < ActiveRecord::Base

  belongs_to :kudo
  belongs_to :recipient, :class_name => "User"
  belongs_to :folder

  belongs_to :kudoable, :polymorphic => true
  delegate   :author, :created_at, :subject, :body, :recipients, :to => :kudo

  scope :friends,    where(:share_scope => "friends")
  scope :recipients, where(:share_scope => "recipients")

  def copy_recipient
    return if my_kudo?
    return self.recipient.to_s if self.recipient
    self.temporary_recipient   if self.recipient.blank?
  end

  def my_kudo?
    self.recipient == self.author
  end

  def visible_for? user = nil
    return true if share_scope.blank?
    return true if user == author
    return true if user == recipient && share_scope == 'recipients'
    return true if author.is_my_friend(user) && share_scope == 'friends'
    false
  end

end
