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
  belongs_to :user

  # ================
  # ==== scopes ====
  # ================
  scope :emails,   where(:identity_type => "email")
  scope :twitters, where(:identity_type => "twitter")
  scope :confirmed_for_user, ->(search_term, user) { joins(:confirmation).joins(:user).
                                                       where("user_id <> ?", user.id).
                                                       where(:confirmations => {:confirmed => true}).
                                                       where("lower(identity) LIKE lower(?) OR lower(users.first_name)  \
                                                              LIKE lower(?) OR lower(users.last_name) LIKE lower(?) OR lower(users.company_name) LIKE lower(?)",
                                                              "%#{search_term}%", "#{search_term}%", "#{search_term}%", "#{search_term}%") }
  scope :exact_twitter_for_user, ->(search_term, user) { joins(:confirmation).joins(:user).
                                                       where("user_id <> ?", user.id).
                                                       where(:confirmations => {:confirmed => true}).
                                                       where("lower(identity) = lower(?) AND identity_type = (?) ", "#{search_term}", 'twitter') }

  # ================
  # == extensions ==
  # ================
  acts_as_mergeable

  include OurKudos::Confirmable
  include OurKudos::Api::DateTimeFormatter
  # ================
  # = ar callbacks =
  # ================
  before_destroy :can_destroy?  
  after_save :save_confirmation,          :if => :needs_it?
  after_save :save_twitter_confirmation!, :if => :is_twitter?

  # ====================
  # = instance methods =
  # ====================
  def can_destroy?
    !is_primary? 
  end

  def synchronize_email!
    self.update_attribute :identity, self.user.email
  end

  def mergeable?
    user && !user.has_role?(:admin)
  end

  def set_as_tetriary!
    self.is_primary = false
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
     return "email" if string =~ RegularExpressions.email
     "twitter"      if string =~ RegularExpressions.twitter
  end

  def self.find_for_authentication string
    identity = where(:identity      => string.gsub(/^@{1}/,'').downcase,
                     #:identity_type => get_type(string)).
                     ).
               joins(:user).joins(:confirmation).first

    return nil if identity.blank? || (identity && !identity.confirmation.confirmed?)
    identity
  end


  #builds dynamically 3 methods - is_twitter?, is_email?, is_name?
  self.options_for_identity_type.map(&:last).each do |type|
    define_method "is_#{type}?" do
      self.identity_type == type.to_s
    end
  end
  

end
