class Identity < ActiveRecord::Base

  # ================
  # = validations  =
  # ================
  validates :identity, :presence => true
  validates :identity, :format => { :with => RegularExpressions.email },
                       :if     => :is_email?

  validates :identity, :identity_primary => true
  validates :identity, :uniqueness       => true
  validates :identity, :email            => true, :if => :is_email?
  validates :identity, :twitter          => true, :if => :is_twitter?

  # ================
  # = associations =
  # ================
  has_one :confirmation, :as => :confirmable, :dependent => :destroy
  belongs_to :user

  # ================
  # ==== scope======
  # ================
  scope :emails,  :identity_type => "email"
  scope :twitters,:identity_type => "twitter"
  scope :for,   ->(user) { where(:user_id => user.id) }
  # ================
  # == extensions ==
  # ================
  acts_as_mergeable

  include OurKudos::Confirmable

  # ================
  # = ar callbacks =
  # ================
  before_destroy :can_destroy?  
  after_save :save_confirmation,          :if => :is_email?
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

  #builds dynamically 3 methods - is_twitter?, is_email?, is_name?
  [:twitter, :email, :name].each do |type|
    define_method "is_#{type}?" do
      self.identity_type == type.to_s
    end
  end

  def save_twitter_confirmation!
     create_confirmation(:confirmable_type  => self.class.name,
                          :confirmable_id   => self.id,
                          :confirmed        => true) if needs_confirmation?
  end

  # =================
  # = class methods =
  # =================
  class << self

    def options_for_identity_type
      [['email', 'email'],
       ['name', 'name'],
       ['twitter nick name', 'twitter']
      ]
    end

  end

end
