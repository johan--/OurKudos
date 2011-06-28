class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,:omniauthable,
         :recoverable, :rememberable, :trackable,  :token_authenticatable, 
         :timeoutable, :encryptable, :encryptor => :sha512, 
         :token_authentication_key => :oauth_token
         
  attr_accessible :email, :password, :password_confirmation, :remember_me, 
                  :first_name, :last_name, :streetadress, :city, :state_or_province,
                  :postal_code, :phone_number, :mobile_number, :gender, :role_ids

  attr_accessor :primary_identity, :skip_password_validation, :remember_old_pass
  # ================
  # = associations =
  # ================

  has_many :authentications
  has_many :identities
  has_many :permissions
  has_many :confirmations, :through => :identities
  has_many :merges, :foreign_key => :merged_by, :dependent => :destroy
  has_and_belongs_to_many :roles

  has_many :sent_kudos,     :class_name => "Kudo",     :foreign_key => "author_id",    :conditions => ["removed = ?", false]
  has_many :received_kudos, :class_name => "KudoCopy", :foreign_key => "recipient_id", :dependent => :destroy
  has_many :folders

  has_many :friendships
  has_many :friends,             :through    => :friendships
  has_many :inverse_friendships, :class_name => "Friendship",         :foreign_key => "friend_id"
  has_many :inverse_friends,     :through    => :inverse_friendships, :source      => :user

  has_many :facebook_friends
  has_many :kudo_flags, :foreign_key => :flagger_id
  # ================
  # ====scopes =====
  # ================
  scope :date_range, ->(from, to) { User.where(:created_at => from..to) }
  # ================
  # = validations  =
  # ================
  validates :first_name, :presence => true
  validates :last_name,  :presence => true
  validates :email,      :presence => true, :email => true
  validates :password,   :presence => true, :unless => :skip_password_validation
  validates :password,   :format   => { :with => RegularExpressions.password },
                         :is_forbidden_password => true,
                         :confirmation => true, :unless => :skip_password_validation
  # ================
  # == extensions ==
  # ================

  include OurKudos::Api::DateTimeFormatter
  include OurKudos::FacebookConnection
  include OurKudos::TwitterConnection

  acts_as_ourkudos_client
  # ================
  # = ar callbacks =
  # ================
  before_save :add_role
  after_save  :save_identity
  after_save  :update_identity, :if => :primary_identity
  before_destroy :set_identities_as_destroyable
  after_destroy  :remove_mergeables, :destroy_friendships
  before_create :build_inbox
  # ================
  # == pg indexes ==
  # ================
  #TODO define more indexes as needed
  index do
    email
    first_name
    last_name
    middle_name
  end
  # ======================
  # == instance methods ==
  # ======================
  def to_s
    "#{first_name} #{middle_name} #{last_name}"
  end
  
  def apply_omniauth omniauth, skip_user = false
    unless omniauth['credentials'].blank?
      authentications.build(:provider => omniauth['provider'], 
                            :uid      => omniauth['uid'],
                            :nickname => omniauth.recursive_find_by_key("nickname"),
                            :token    => omniauth['credentials']['token'], 
                            :secret   => omniauth['credentials']['secret'])
    else
      authentications.build(:provider => omniauth['provider'], 
                            :uid      => omniauth['uid'],
                            :nickname => omniauth.recursive_find_by_key("nickname"))    
    end
      look_for_other_fields(omniauth) if skip_user.blank?
  end

  def look_for_other_fields omniauth
    self.email      = omniauth.recursive_find_by_key("email")      if self.email.blank? && omniauth.recursive_find_by_key("email")
    self.last_name  = omniauth.recursive_find_by_key("last_name")  if omniauth.recursive_find_by_key("last_name")
    self.first_name = omniauth.recursive_find_by_key("first_name") if omniauth.recursive_find_by_key("first_name")
    self.gender     = omniauth.recursive_find_by_key("gender")     if omniauth.recursive_find_by_key("gender")
  end

  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.include?(role_sym.to_s) }
  end

  def assign_roles
   self.roles = [] if role_ids.blank?
   self.roles = role_ids.map {|id| Role.find id }
  end

  def render_roles
   roles.map(&:name).join(", ")
  end

  def add_role
   self.roles << Role.find_or_create_by_name("user") unless has_role?(:user)
  end

  def remove_mergeables
    Merge.mergeables.each do |mergeable|
      mergeable.for(self).destroy_all
    end
  end

  def render_providers
    authentications.map(&:provider).push("our kudos").reverse.join(", ")
  end

  def has_email_identity? email
    identities.emails.map(&:identity).include? email
  end
 
  def current_providers
    authentications.map(&:provider)
  end

  def my_options_for_providers
   Authentication.options_for_provider.select {|provider| provider.last unless current_providers.include? provider.last}
  end

  def save_identity
     if self.identities.blank?
      identity = self.identities.create :identity      => self.email,
                                        :is_primary    => true,
                                        :identity_type => "email"
      identity.save :validate => false
     end
  end

  def update_identity
    old_email = primary_identity.identity

    primary_identity.synchronize_email! if primary_identity_changed && old_email != email
    self.primary_identity = nil
    primary_identity
  end

  def primary_identity
    @primary_identity ||= identities.find_by_is_primary true
  end

  def primary_identity_changed
    @primary_identity_changed ||= self.email_changed?
  end

  def set_identities_as_destroyable
    Identity.for(self).each  { |identity| identity.set_as_tetriary! }
  end

  def is_confirmed?
    return true  if confirmed?
    return false if primary_identity.blank?
    return false if primary_identity.confirmation.blank?

    save_confirmed_cache
  end

  def save_confirmed_cache
    update_attribute :confirmed, true if !self.confirmed && primary_identity.confirmation.confirmed?
  end

  def current_recipient_for identity
    return identity.identity if identities.size > 1
    self.email
  end

  def current_first_name_for identity
    return identity.identity if identities.size > 1
    self.first_name
  end

  def active_for_authentication?
    super && is_confirmed?
  end

  def set_new_token_to! token
    update_attribute :authentication_token, token
  end

  def inbox
    folders.find_by_name I18n.t(:inbox_name)
  end

  def build_inbox
    folders.build :name => I18n.t(:inbox_name)
  end

  def add_friend friend
    return false if is_my_friend? friend
    friendships.create :friend_id => friend.id
    true
  end

  def is_my_friend? friend
     !(friendship_for friend).blank?
  end

  def friendship_for person
    friendships.select {|f| f.friend == person }.first
  end

  def any_email_kudos?
    !(EmailKudo.where(:email => self.email)).blank?
  end

  def save_my_invitations_in_inbox
    KudoCopy.move_invitation_kudos_to(self) if any_email_kudos? && received_kudos.blank?
  end

  def identities_ids
    @identities_ids ||= identities.map(&:id)
  end

  def emails
    @identities_emails ||= identities.emails.map(&:identity)
  end

  def friends_ids_list
    friends.map {|friend| friend.id }.sort.join(", ")
  end

  def newsfeed_kudos
   !friends_ids_list.blank? ?
    (@newsfeed_kuds ||= User.newsfeed_kudos(self)) : []
  end

  def destroy_friendships
    Friendship.where(:friend_id => self.id).destroy_all
  end

  def password_salt= password_salt
    self.old_password_salt = self.password_salt           if remember_old_pass
    @password_salt = password_salt
    write_attribute :password_salt, @password_salt
  end

  def encrypted_password= encrypted_password
    self.old_encrypted_password = self.encrypted_password  if remember_old_pass
    @encrypted_password = encrypted_password
    write_attribute :encrypted_password, @encrypted_password
  end

  def undo_last_password_change!
    self.password_salt      = self.old_password_salt
    self.encrypted_password = self.old_encrypted_password
    save :validate => false
  end

  def my_improperly_flagged_kudos
    @improperly_flagged_kudos ||= KudoFlag.improperly_flagged_for self
  end

  def improperly_flagged_kudos_authors_ids
    my_improperly_flagged_kudos.map {|kf| kf.flagged_kudo.author_id }.flatten
  end

  # returns a hash of authors i.e {3 => 3, means = author_id => with 3 improperly flagged kudos)
  # we will check that number changes each time users flag improperly given kudo for given author
  #penalty score will depend on it.
  def improperly_flagged_kudos_authors_counted_hash
    hash = Hash.new(0)  # with default value 0

    improperly_flagged_kudos_authors_ids.each do |author_id|
      hash[author_id] += 1
    end

    hash
  end

  def get_factor_for author
    authors = improperly_flagged_kudos_authors_counted_hash

    return 5 if !authors.keys.include?(author.id)

    case authors[author.id]
      when 0..5   ; return 6
      when 6..10  ; return 7
      when 10..20 ; return 8
      when authors[author.id] > 20; return 10
    end

  end

  #each time user flags kudo as invalid
  def increase_penalty_score! author
    update_attribute :penalty_score, (my_improperly_flagged_kudos.size * get_factor_for(author)).to_i
    penalty_score
  end

  def decrease_penalty_score! factor = 5
    update_attribute :penalty_score, (my_improperly_flagged_kudos.size * factor).to_i
  end



  class << self

    def get_identity_user_by email
        email = email.downcase
        recoverable = Identity.find_by_identity_and_identity_type(email,'email').user rescue nil

        recoverable = find_or_initialize_with_errors(reset_password_keys, {:email => email}, :not_found) if recoverable.blank?

        recoverable.send_reset_password_instructions(email) if recoverable && !recoverable.new_record? &&
                                                                            !email.blank? && email =~ RegularExpressions.email
        recoverable
    end

    def newsfeed_kudos user
      Kudo.public_or_friends_kudos.author_or_recipient user
    end

  end


end
