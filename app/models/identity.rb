class Identity < ActiveRecord::Base
  belongs_to :user

  validates :identity, :presence => true
  validates :identity, :format => { :with => RegularExpressions.email },
                       :if     => ->(id) { id.identity_type == 'email'}

  validates :identity, :identity_primary => true

  ### ACTIVE RECORD SCOPES ###
  scope :for_user,   ->(user)  { where(:user_id => user.id) }
  scope :with_email, ->(email) { where(:identity => email).where(:identity_type => "email") }


  before_destroy :can_destroy?

  def is_primary?
    self.identity == self.user.email
  end

  def can_destroy?
    !is_primary?
  end

  def make_me_primary_again!
    self.update_attribute :identity, self.user.email
  end

  class << self

    def options_for_identity_type
      [['email', 'email'],
       ['name', 'name'],
       ['twitter nick name', 'twitter']
      ]
    end


  end

end
