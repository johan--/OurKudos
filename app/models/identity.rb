class Identity < ActiveRecord::Base


  attr_accessor :no_confirmation
  # ================
  # = validations  =
  # ================
  validates :identity, :presence => true
  validates :identity, :format => { :with => RegularExpressions.email },
                       :if     => :is_email?

  validates :identity, :identity_primary => true, :on => :update
  validates :identity, :uniqueness       => true
  validates :identity, :email            => true, :if => :is_email?
  validates :identity, :twitter          => true, :if => :is_twitter?

  # ================
  # = associations =
  # ================
  has_one :confirmation, :as => :confirmable, :dependent => :destroy
  #belongs_to :user
  belongs_to :identifiable, :polymorphic => true

  # ================
  # ==== scopes ====
  # ================
  scope :emails,   where(:identity_type => "email")
  scope :twitters, where(:identity_type => "twitter")
  scope :confirmed_for_user, ->(search_term, user) { joins(:confirmation).joins('INNER JOIN users ON users.id = identities.identifiable_id').
                                                       where("identifiable_id <> ? AND identity_type <> ?", user.id, 'twitter').
                                                       where(:confirmations => {:confirmed => true}).
                                                       where("lower(identity) LIKE lower(?) OR lower(users.first_name)  \
                                                              LIKE lower(?) OR lower(users.last_name) LIKE lower(?) OR lower(users.company_name) LIKE lower(?)",
                                                              "%#{search_term}%", "#{search_term}%", "#{search_term}%", "#{search_term}%") }

  scope :twitter_for_user, ->(search_term, user) { joins(:confirmation).
                                                       where("identifiable_id <> ?", user.id).
                                                       where("identity_type = ?",'twitter').
                                                       where("lower(identity) LIKE lower(?)", "#{search_term}%").
                                                       where(:confirmations => {:confirmed => true})}

  scope :virtual_for_user, ->(search_term, user) {  where("identifiable_id <> ?", user.id).
                                                    where("identifiable_type = ?", "VirtualUser").
                                                     where("lower(identity) LIKE lower(?)", "#{search_term}%")}

  scope :exact_twitter_for_user, ->(search_term, user) { joins(:confirmation).joins(:user).
                                                       where("identifiable_id <> ?", user.id).
                                                       where(:confirmations => {:confirmed => true}).
                                                       where("lower(identity) = lower(?) AND identity_type = (?) ", "#{search_term}", 'twitter') }
  scope :by_type, :order => 'identity_type ASC'

  # ================
  # == extensions ==
  # ================
  acts_as_mergeable

  include OurKudos::Confirmable
  include OurKudos::Api::DateTimeFormatter
  # ================
  # = ar callbacks =
  # ================
  before_validation :downcase_email_identity
  before_destroy :can_destroy?  
  after_save :save_confirmation,          :if => :needs_it?
  after_save :save_twitter_confirmation!, :if => :is_twitter?
  after_save :update_virtual_user, :if => :is_twitter?

  # ====================
  # = instance methods =
  # ====================
  def can_destroy?
    !is_primary? && !display_identity?
  end

  def synchronize_email!
    self.update_attribute :identity, self.user.email
  end

  def user
    self.identifiable
  end

  def mergeable?
    user && !user.has_role?(:admin)
  end

  def set_as_tetriary!
    self.is_primary = false
    self.display_identity = false
    self.save :run_callbacks => false, :validate => false
  end

  def save_twitter_confirmation!
     create_confirmation(:confirmable_type  => self.class.name,
                          :confirmable_id   => self.id,
                          :confirmed        => true) if needs_confirmation?
  end

  def confirmed?
    confirmation.confirmed?
  end

  def primary_identity_confirmed?
    is_primary? && confirmed?
  end

  def needs_it?
    is_email? || is_nonperson?
  end
  
  def downcase_email_identity
  	self.identity = self.identity.downcase if self.identity.present? && self.identity_type == 'email'
  end

  def autocomplete_name
    [{ :id => id, :name => (is_twitter? ?
          "#{identifiable.to_s} (Twitter: @#{identity})" :
          "#{identifiable.to_s} (Email)")}]
  end

  def update_virtual_user
    return true unless identifiable_type == 'VirtualUser'
    return identifiable.update_from_twitter self.identity
  end
  handle_asynchronously :update_virtual_user


  # =================
  # = class methods =
  # =================

  def self.options_for_identity_type
    [['email', 'email'],
     ['name', 'name'],
     ['company/business', 'nonperson'],
     ['twitter nick name', 'twitter']
    ]
  end

  def self.get_type string
     return "email"     if string =~ RegularExpressions.email
     return "nonperson" if string =~ RegularExpressions.word && string !=~ RegularExpressions.email
     "twitter"          if string =~ RegularExpressions.twitter
  end

  def self.find_for_authentication string
    identity = where(:identity      => string.gsub(/^@{1}/,'').downcase).
               where("identities.identity_type = ? OR identities.identity_type = ?",
                     'nonperson', 'email').
              joins('INNER JOIN users ON users.id = identities.identifiable_id').joins(:confirmation).first

    return nil if identity.blank? || (identity && !identity.confirmation.confirmed?)
    identity
  end


  #builds dynamically 3 methods - is_twitter?, is_email?, is_name?
  self.options_for_identity_type.map(&:last).each do |type|
    define_method "is_#{type}?" do
      self.identity_type == type.to_s
    end
  end
  
  def self.update_display_identity(user, new_display_identity)
    old = Identity.where(:display_identity => true, :identifiable_id => user.id, :identifiable_id => user.class.to_s).first
    return false unless old.update_attribute('display_identity', false)
    new = Identity.find(new_display_identity)
    return false unless new.update_attribute('display_identity', true)
    true
  end

end
