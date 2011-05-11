class Identity < ActiveRecord::Base
  belongs_to :user

  validates :identity, :presence => true
  validates :identity, :format => { :with => RegularExpressions.email },
                       :if     => ->(id) { id.identity_type == 'email'}

  validates :identity, :identity_primary => true


  acts_as_merged

  before_destroy :can_destroy?

  def is_primary?
    self.identity == self.user.email rescue false
  end

  def can_destroy?
    !is_primary? 
  end

  def make_me_primary_again!
    self.update_attribute :identity, self.user.email
  end

  def change_my_owner_to! user
    Identity.transaction do
      old_owner = self.user
      self.update_attribute :user_id, user.id
      old_owner.destroy
    end
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
