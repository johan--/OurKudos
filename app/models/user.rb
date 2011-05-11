class User < ActiveRecord::Base


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable, :lockable, :timeoutable, 
         :omniauthable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name,
                  :streetadress, :city, :state_or_province, :postal_code, :phone_number, :mobile_number, 
                  :gender, :role_ids

  attr_accessor :primary_identity

  #=== relationships ===#

  has_many :authentications
  has_many :identities
  has_many :merges, :foreign_key => :merged_by
  has_and_belongs_to_many :roles

  #=== validations  ===#
  validates :first_name, :presence => true
  validates :last_name, :presence => true

  
  after_initialize :primary_identity   #remember current primary identity
  after_save :update_primary_identity, :write_first_identity

  #TODO define more indexes as needed
  index do
    email
    first_name
    last_name
    middle_name
  end
    
  def to_s
    "#{first_name} #{middle_name} #{last_name}"
  end
  
  def apply_omniauth omniauth
    unless omniauth['credentials'].blank?
      authentications.build(:provider => omniauth['provider'], 
                            :uid      => omniauth['uid'],
                            :token    => omniauth['credentials']['token'], 
                            :secret   => omniauth['credentials']['secret'])
    else
      authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
      self.email = omniauth.recursive_find_by_key("email")
    end
      self.email      = omniauth.recursive_find_by_key("email")
      self.last_name  = omniauth.recursive_find_by_key("last_name")
      self.first_name = omniauth.recursive_find_by_key("first_name")
      self.gender     = omniauth.recursive_find_by_key("gender")
  end
  
  def resource_type
    self.class.name.underscore.to_sym
  end

 def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
 end

 def assign_roles
   user.roles = [] if roles_ids.blank?
   
   user_roles = roles_ids.each {|id| Role.find id }
   user.roles = user_roles
 end

 def render_roles
   roles.map(&:name).join(", ")
 end

 def can_save_first_identity?
   return true if new_record?
   return true if self.identities.blank?
   false
 end

 def write_first_identity   
   if self.identities.blank?
    identity = self.identities.create :identity      => self.email,
                                      :is_primary    => true,
                                      :identity_type => "email"
    identity.save :validate => false
   end   
 end

 def primary_identity
   @primary_identity ||= identities.find_by_is_primary true
 end

 def primary_identity_changed
   @primary_identity_changed ||= self.email_changed?   
 end

 def update_primary_identity
   old_email = primary_identity.identity if primary_identity

   if old_email != email && primary_identity_changed
    primary_identity.synchronize_email!
    self.primary_identity = nil
   end
   primary_identity
 end

 def give_mergeables_to new_user
   User.transaction do
     User.mergeables.each do |model|
       objects = self.send model.to_s.underscore.pluralize
       model.change_objects_owner_to objects, new_user
     end
   end
 end

 class << self

   def mergeables
     OurKudos::Acts::Mergeable.mergeables # (i.e [Identity, Authentication])
   end


 end

  
end
