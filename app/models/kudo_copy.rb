class KudoCopy < ActiveRecord::Base

  belongs_to :kudo
  belongs_to :recipient, :class_name => "User"
  belongs_to :folder

  belongs_to :kudoable, :polymorphic => true
  delegate   :author, :created_at, :subject, :body, :recipients, :to => :kudo

  scope :friends,    where(:share_scope => "friends")
  scope :recipients, where(:share_scope => "recipients")
  scope :for_email,  ->(email) { where(:temporary_recipient => email) }

  def copy_recipient
    return if own_kudo?
    return self.recipient.to_s        unless self.recipient.blank?
    return self.temporary_recipient   if self.recipient.blank? && self.kudoable.is_a?(EmailKudo)
    self.facebook_friend.name         if self.recipient.blank? && self.kudoable.is_a?(FacebookFriend)
  end

  def own_kudo?
    self.recipient == self.author && !self.author.blank?
  end

  def visible_for? user = nil
    return true if share_scope.blank?
    return true if user == author
    return true if share_scope == 'recipients' && user == recipient
    return true if share_scope == 'friends' && author.is_my_friend?(user)
    false
  end

  class << self

   def move_invitation_kudos_to user
     KudoCopy.for_email(user.email).each do |kudo|
       kudo.kudoable.destroy
       kudo.recipient           = user
       kudo.folder              = user.inbox
       kudo.temporary_recipient = nil
       kudo.kudoable            = kudo.kudo
       kudo.save :validate => false
     end
   end

  end

end
