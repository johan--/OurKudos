class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,:omniauthable,
         :recoverable, :rememberable, :trackable,  :token_authenticatable,
         :timeoutable, :encryptable, :encryptor => :sha512
         
  attr_accessible :email, :password, :password_confirmation, :remember_me, 
                  :first_name, :last_name, :streetadress, :city, :state_or_province,
                  :postal_code, :phone_number, :mobile_number, :gender, :role_ids

  attr_accessor :primary_identity
  include OurKudos::Lockable
  # ================
  # = associations =
  # ================

  has_many :authentications
  has_many :identities
  has_many :merges, :foreign_key => :merged_by, :dependent => :destroy
  has_and_belongs_to_many :roles

  # ================
  # = validations  =
  # ================
  validates :first_name, :presence => true
  validates :last_name,  :presence => true
  validates :email,      :presence => true, :uniqueness => true, :email => true
  validates :password,   :presence => true, :length => { :minimum => 6, :maximum => 40 },
                                           :confirmation => true, :if => :new_record?

  # ================
  # = ar callbacks =
  # ================
  before_save :add_role
  after_save  :save_identity
  after_save  :update_identity, :if => :primary_identity
  before_destroy :set_identities_as_destroyable
  after_destroy  :remove_mergeables  # can't use :depended destroy because it's too early for this event, need this method though

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
  
  def apply_omniauth omniauth
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
      look_for_other_fields omniauth
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

 def add_role
   self.roles << Role.find_or_create_by_name("user") unless has_role?(:user)
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
   return self.email 
 end

 def twitter_handles
  @twitter_handles ||= authentications.select {|a| a.provider == 'twitter'}.map(&:nickname).compact
 end

 def has_twitter_handle?(nickname)
   twitter_handles.any? { |handle| handle == nickname.gsub(/^@{1,}/, '') }
 end

 def remove_mergeables
    Merge.mergeables.each do |mergeable|
      mergeable.for(self).destroy_all
    end
 end

 def render_providers
   authentications.map(&:provider).push("our kudos").reverse.join(", ")
 end
 
 def current_providers
   authentications.map(&:provider)
 end

 def my_options_for_providers
   Authentication.options_for_provider.select {|provider| provider.last unless current_providers.include? provider.last}
 end

end
