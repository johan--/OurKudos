class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,:omniauthable,
         :recoverable, :rememberable, :trackable,  :token_authenticatable, 
         :timeoutable, :encryptable, :encryptor => :sha512, 
         :token_authentication_key => :oauth_token
         
  attr_accessible :email, :password, :password_confirmation, :remember_me, 
                  :first_name, :last_name, :streetadress, :address2, :city, :state_or_province,
                  :postal_code, :phone_number, :mobile_number, :gender, :role_ids,
                  :profile_picture, :birthday, :hide_birth_year, :tos, :is_banned,
                  :first_message, :company_name, :time_zone

  attr_accessor :primary_identity, :skip_password_validation,
                :remember_old_pass, :consider_invitation_email, :has_company,
                :send_penalty_notification, :first_message, 
                :display_identity_name, :display_name
  # ================
  # = associations =
  # ================

  has_many :authentications
  has_many :identities
  has_many :permissions
  has_many :confirmations, :through => :identities
  has_many :merges, :foreign_key => :merged_by, :dependent => :destroy
  has_and_belongs_to_many :roles

  has_many :sent,     :class_name => "Kudo",     :foreign_key => "author_id",    :conditions => ["removed = ?", false]
  has_many :received, :class_name => "KudoCopy", :foreign_key => "recipient_id", :include => :kudo, :dependent => :destroy
  has_many :folders

  has_many :friendships
  has_many :friends,             :through    => :friendships
  has_many :inverse_friendships, :class_name => "Friendship",         :foreign_key => "friend_id"
  has_many :inverse_friends,     :through    => :inverse_friendships, :source      => :user

  has_many :facebook_friends
  has_many :kudo_flags, :foreign_key => :flagger_id

  has_many :comments
  has_many :pictures
  has_one :messaging_preference
  # ================
  # ====scopes =====
  # ================
  scope :date_range, ->(from, to) { where(:created_at => from..to) }
  # ================
  # = validations  =
  # ================
  validates :first_name,    :presence => true, :unless => :has_company
  validates :last_name,     :presence => true, :unless => :has_company
  validates :last_name,     :presence => true, :unless => :has_company
  validates :email,         :presence => true, :email => true
  validates :password,      :presence => true, :unless => :skip_password_validation
  validates :password,      :format   => { :with => RegularExpressions.password },
                            :is_forbidden_password => true,
                            :confirmation => true, :unless => :skip_password_validation

  validates :company_name, :presence => true, :if => :has_company

  validates_acceptance_of :tos, :on        => :create,
                                :message   => I18n.t(:tos_must_be_accepted),
                                :accept    => '1'
  validates :postal_code,		:presence => true
  
  # ================
  # == extensions ==
  # ================

  include OurKudos::Api::DateTimeFormatter
  include OurKudos::FacebookConnection
  include OurKudos::TwitterConnection
  include OurKudos::OkGeo

  acts_as_ourkudos_client
  # ================
  # = ar callbacks =
  # ================
  before_validation :downcase_email
  before_save :add_role
  after_save  :save_identity
  after_save  :update_identity, :if => :primary_identity
  after_save  :flag_abuse_notification
  after_save  :create_messaging_preferences, :on => :create
  before_destroy :set_identities_as_destroyable
  after_destroy  :remove_mergeables, :destroy_friendships
  before_create :build_inbox
  after_update :deliver_ban_notification!
  # ======================
  # == full text search ==
  # ======================

  include PgSearch
  pg_search_scope :search,
                  :against => [:first_name, :last_name, :middle_name, :email]


  # ======================
  # ====== avatars =======
  # ======================

  has_attached_file :profile_picture, :styles => {
      :large    => "300x300!",
      :medium   => '150x150!',
      :small    => "50x50#"
  }

    include Gravtastic
    gravtastic :email, :secure => true, :filetype => :png, :size => 50


  serialize :profile_picture_priority
  # ======================
  # == instance methods ==
  # ======================
  def to_s
    if self.first_name.blank? && self.last_name.blank?
      self.company_name
    else
      return "#{first_name} #{last_name}" if middle_name.blank?
      "#{first_name} #{middle_name} #{last_name}"
    end
  end

  def secured_name
  	return company_name if !company_name.nil?
  	return  "@#{display_identity.identity}" if display_identity.identity_type == "twitter" && !display_identity.blank?
    return "#{first_name} #{last_name.first.capitalize}." if middle_name.blank?
    "#{first_name} #{middle_name.first.capitalize}. #{last_name.first.capitalize}."
  end

  def first_or_company_name
    return company_name unless self.company_name.blank?
    first_name
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
    self.email             = omniauth.recursive_find_by_key("email")      if self.email.blank? && omniauth.recursive_find_by_key("email")
    self.last_name         = omniauth.recursive_find_by_key("last_name")  if omniauth.recursive_find_by_key("last_name")
    self.first_name        = omniauth.recursive_find_by_key("first_name") if omniauth.recursive_find_by_key("first_name")
    self.gender            = omniauth.recursive_find_by_key("gender")     if omniauth.recursive_find_by_key("gender")
    self.social_picture_fb = omniauth.recursive_find_by_key("image")      if omniauth.recursive_find_by_key("image") && omniauth['provider'] == 'facebook'
    self.social_picture_tw = omniauth.recursive_find_by_key("image")      if omniauth.recursive_find_by_key("image") && omniauth['provider'] == 'twitter'
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

  def facebook_identifier
    return nil unless current_providers.include?('facebook')
    authentications.find_by_provider('facebook').uid
  end

  def my_options_for_providers
   Authentication.options_for_provider.select {|provider| provider.last unless current_providers.include? provider.last}
  end

  def save_identity
     if self.identities.blank?

      identity = self.identities.create :identity        => primary_identity_value,
                                        :is_primary      => true,
                                        :display_identity=> true,
                                        :no_confirmation => !self.first_message.blank?,
                                        :identity_type   => primary_identity_type,
                                        :is_company      => has_company
      identity.save :validate => false
     end
  end

  def primary_identity_type
    return 'nonperson' if has_company
    'email'
  end

  def primary_identity_value
    return self.company_name unless self.company_name.blank?
    self.email
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

  def display_identity
    @display_identity ||= identities.find_by_display_identity true
    if @display_identity.blank?
      @display_identity = primary_identity
    else
      @display_identity
    end
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
    update_attribute :confirmed, true if !self.confirmed && primary_identity.confirmed?
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

  def local_kudos
   !postal_code.blank? ?
    (@local_kudos ||= Kudo.local_kudos(self)) : []
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
    self.send_penalty_notification = true if penalty_score > 30
    penalty_score
  end

  def decrease_penalty_score! factor = 5
    update_attribute :penalty_score, (my_improperly_flagged_kudos.size * factor).to_i
  end

  def to_param
    "#{self.id}-#{self.to_s.underscore.gsub(" ",'-')}"
  end

  def current_profile_picture size = :small
    avatar_from_position 1, size
  end

  def profile_picture_from type, position, size = :small
   case type
      when :system
        has_profile_picture? ?
            profile_picture(size) : avatar_from_position(position + 1)
     when :gravatar
       gravatar_url :default => avatar_from_position(position+1), :size => gravatar_size(size)
     when :facebook
       social_picture_fb.blank? ?
           avatar_from_position(position+1) : social_picture_fb
     when :twitter
       social_picture_tw.blank? ?
           'avatar_unknown.png' : social_picture_tw
    end
  end

  def gravatar_size size = :small
    return 50 if size == :small
    100
  end

  def has_profile_picture?
    !profile_picture(:small).to_s.include?("missing")
  end

  def avatar_from_position position, size = :small
    profile_picture_from profile_picture_priority[position], position, size
  end

  def remove_system_avatar!
    update_attribute :profile_picture, nil
  end

  def set_new_profile_pictures_order data_string, save = false

    data_string.split(",").each_with_index do |picture_type, index|
       profile_picture_priority[index+1] = picture_type.downcase.to_sym
    end

    save(:validate => false) if save

    self.profile_picture_priority
  end

  def get_url_for_type type
    case type
      when :facebook ; social_picture_fb.blank? ?
          'avatar_unknown.png' : social_picture_fb.to_s
      when :twitter  ; social_picture_tw.blank? ?
          'avatar_unknown.png' : social_picture_tw.to_s
      when :system   ; has_profile_picture? ?
          profile_picture(:small) :  'avatar_unknown.png'
      when :gravatar ; gravatar_url.to_s
    end

  end

  def flag_abuse_notification
    UserNotifier.delay.flag_abuse(self) if penalty_score >= 30  && self.send_penalty_notification
  end

  def create_messaging_preferences
    MessagingPreference.create(:user_id => self.id)
  end

  def increase_invitations type
    column = "invitations_#{type}".to_sym
    update_attribute column, self.send(column) + 1
  end

  def demographics
    "#{city} #{state_or_province}"       if city && state_or_province
    "#{city}, state unknown"             if city && state_or_province.blank?
    "city unknown, #{state_or_province}" if city.blank? && state_or_province
    "city unkown, state uknown"          if city.blank? && state_or_province.blank?
  end

  def deliver_ban_notification!
    UserNotifier.delay.you_are_banned(self) if is_banned?
  end

  def send_reply_kudo! author_id
    User.transaction do
      identity = User.find(author_id).primary_identity.id

      Kudo.for_identity self.id, identity, first_message
    end
  end

  def comment_invitation_kudo key
    User.transaction do
       copy = KudoCopy.find key
       copy.kudo.comments.create :comment => first_message,
                                 :user_id => self.id
    end
  end

  def received_kudos
    received.for_dashboard.
            select("distinct kudo_copies.*, kudos.*").group User.grouping_order
  end

  def sent_kudos
    #sent.for_dashboard.select("distinct kudos.*").group User.grouping_order
    # various joins in for_dashboard scope are removing legitimate kudos
    sent
  end

  def company?
    self.has_company = !self.company_name.blank?
  end
  
  def downcase_email
  	self.email = self.email.downcase if self.email.present?
  end

  class << self

    def get_identity_user_by email
        email = email.downcase

        recoverable = Identity.find_by_identity_and_identity_type(email,'email').user rescue nil

        recoverable = find_or_initialize_with_errors(reset_password_keys, {:email => email}, :not_found) if recoverable.blank?

        if recoverable && !recoverable.new_record? && !email.blank? && email =~ RegularExpressions.email
          recoverable.send_reset_password_instructions(email)
        end
        recoverable
    end

    def newsfeed_kudos user
      Kudo.newsfeed_for user
    end

    def newsfeed_for user
      joins(:sent).joins(:received).
          joins(left_joins_categories).joins(left_joins_comments).
          select("DISTINCT kudos.*")
    end


    def local_users user
      unless user.postal_code.blank?
        zip_codes = OurKudos::OkGeo.find_local_zip_codes(user.postal_code) 
        zip_codes << user.postal_code

        User.find_all_by_postal_code(zip_codes).collect(&:id).join(",")
      else
        user.id.to_s
      end
    end

    def default_profile_picture_types
      { 1   => :system,   2 => :gravatar,
        3   => :facebook, 4 => :twitter}
    end

  end

end
