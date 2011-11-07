class KudoCopy < ActiveRecord::Base

  belongs_to :kudo
  #belongs_to :recipient, :class_name => "User"
  belongs_to :recipient, :polymorphic => true
  #belongs_to :recipientable, :polymorphic => true, :foreign_key => 'recipient_id'
  belongs_to :folder

  belongs_to :kudoable, :polymorphic => true
  belongs_to :author,   :class_name => "User"

  has_many :comments, :through => :kudo

  delegate   :category, :created_at, :subject, :body, :recipients, :comments_count, :to => :kudo

  scope :friends,                        where(:share_scope => "friends")
  scope :recipients,                     where(:share_scope => "recipients")
  scope :for_email,  ->(email) {         where(:temporary_recipient => email) }
  scope :for_dashboard,  joins(:kudo).joins(:author).joins(left_joins_categories).joins(left_joins_comments)


  #needs Refactoring
  def copy_recipient
    return if own_kudo?
    return if copy_recipient_is_author?
    #need check if recipient is deleted
    return self.recipient.virtual_name if recipient_type == 'VirtualUser' && recipient_id.present?
    return temporary_recipient.match(RegularExpressions.email_username)[0] if self.recipient_id.blank? && self.kudoable.is_a?(EmailKudo)
    if self.recipient_id.present? 
      if self.kudoable.is_a?(Kudo)
        unless self.recipient.blank?
          return self.recipient.secured_name  
        end
      else
  #this is needed because when an email kudo member joins, kudo is not converted
        unless self.recipient.blank?
          return self.recipient.secured_name  
        end
      end
    end
    return facebook_friend_secured_name  if self.recipient_id.blank? && self.kudoable.is_a?(FacebookKudo)
    "@#{self.temporary_recipient}"       if self.recipient_id.blank? && self.kudoable.is_a?(TwitterKudo)
  end

  def facebook_friend
    @facebook_friend ||= FacebookFriend.find_by_facebook_id self.temporary_recipient
  end

  def facebook_friend_secured_name
    facebook_friend.blank? ?  "unknown recipient" :
        "#{facebook_friend.first_name} #{facebook_friend.last_name.first}."
  end

  def own_kudo?
    return self.recipient_id == self.author_id && recipient_type == 'User' unless self.author_id.blank?
    false
  end

  #can be merged with own_kudo? method
  #REFACTOR
  def copy_recipient_is_author?
    if author
      return true if own_kudo?
      author_ids = author.identities.map{|i| i.identity}
      return true if author_ids.include?(temporary_recipient) 
      unless author.facebook_identifier.blank?
        return true if author.facebook_identifier == temporary_recipient
      end
      return false
    else
      return false
    end
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
