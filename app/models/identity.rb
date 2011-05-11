class Identity < ActiveRecord::Base

  validates :identity, :presence => true
  validates :identity, :format => { :with => RegularExpressions.email },
                       :if     => ->(id) { id.identity_type == 'email'}

  validates :identity, :identity_primary => true


  acts_as_mergeable

  before_destroy :can_destroy?

  def can_destroy?
    !is_primary? 
  end

  def synchronize_email!
    self.update_attribute :identity, self.user.email
  end

  def mergeable?
    user && !user.has_role?(:admin)
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
