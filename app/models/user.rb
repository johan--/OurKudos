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

  has_many :authentications, :dependent => :destroy
  has_many :identities
  has_many :merges, :foreign_key => :merged_by, :dependent => :destroy
  has_and_belongs_to_many :roles

  #=== validations  ===#
  validates :first_name, :presence => true
  validates :last_name, :presence => true

  
  after_initialize :primary_identity   #remember current primary identity
  after_save  :write_identity
  before_destroy :set_identities_as_destroyable
  after_destroy Proc.new {|user| user.identities.destroy_all }
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

  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  def assign_roles
   self.roles = [] if role_ids.blank?
   self.roles = role_ids.map {|id| Role.find id }
  end

  def render_roles
   roles.map(&:name).join(", ")
  end

  def write_identity
   if self.identities.blank?
    identity = self.identities.create :identity      => self.email,
                                      :is_primary    => true,
                                      :identity_type => "email"
    identity.save :validate => false
   else
     old_email = primary_identity.identity
     
     primary_identity.synchronize_email! if primary_identity_changed && old_email != email
   end
  end

 def primary_identity
   @primary_identity ||= identities.find_by_is_primary true
 end

 def primary_identity_changed
   @primary_identity_changed ||= self.email_changed?   
 end
 
 def give_mergeables_to new_user
   User.transaction do     
     User.mergeables.each do |model|

       objects = self.send model.to_s.underscore.pluralize

       set_identities_as_destroyable if objects.first.is_a?(Identity)

       model.change_objects_owner_to objects, new_user
     end
   end
 end

 def set_identities_as_destroyable
   identities.each  { |identity| identity.set_as_tetriary! }
 end


 class << self

   def mergeables
     OurKudos::Acts::Mergeable.mergeables # (i.e [Identity, Authentication])
   end


 end

  
end
