class KudoCopy < ActiveRecord::Base

  belongs_to :kudo
  belongs_to :recipient, :class_name => "User"
  belongs_to :folder

  belongs_to :kudoable, :polymorphic => true
  belongs_to :author,   :class_name => "User"

  has_many :comments, :through => :kudo

  delegate   :category, :created_at, :subject, :body, :recipients, :comments_count, :to => :kudo

  scope :friends,                        where(:share_scope => "friends")
  scope :recipients,                     where(:share_scope => "recipients")
  scope :for_email,  ->(email) {         where(:temporary_recipient => email) }
  scope :for_dashboard,  joins(:kudo).joins(:author).joins(left_joins_categories).joins(left_joins_comments)


  def copy_recipient
    return if own_kudo?
    return self.recipient.secured_name   unless self.recipient.blank?
    return ''                            if self.recipient.blank? && self.kudoable.is_a?(EmailKudo)
    return facebook_friend_secured_name  if self.recipient.blank? && self.kudoable.is_a?(FacebookFriend)
    "@#{self.temporary_recipient}"       if self.recipient.blank? && self.kudoable.is_a?(TwitterKudo)
  end

  def facebook_friend
    @facebook_friend ||= FacebookFriend.find_by_identifier self.temporary_recipient
  end

  def facebook_friend_secured_name
    facebook_friend.blank? ?  "unknown recipient" :
        "#{facebook_friend.first_name} #{facebook_friend.last_name.first}."
  end

  def own_kudo?
    self.recipient == self.author && !self.author.blank?
  end

  def visible_for? user = nil
    return true  if share_scope.blank?
    return true  if user == author
    return true  if share_scope == 'recipient' && user == recipient
    return true  if share_scope == 'friends' && author && author.is_my_friend?(user)
    return false if user && kudo.flaggers.include?(user.id)
    false
  end

  class << self

   def move_invitation_kudos_to user
     kudos = EmailKudo.where(:email => user.email).
                      map(&:kudo).compact.flatten

     kudos.each do |kudo|
       kudo.kudoable.destroy if kudo.kudoable
       kudo.recipient           = user
       kudo.folder              = user.inbox
       kudo.temporary_recipient = nil
       kudo.kudoable            = kudo.kudo
       kudo.save :validate => false
     end
     user.increase_invitations :accepted
   end




  end

end
