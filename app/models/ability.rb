class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new
      if user.has_role?(:admin)
        can :manage, :all
      elsif user.has_role?(:editor)
        can :manage, KudoFlag
      elsif user.has_role?(:gift)
        can :manage, Gift
        can :manage, GiftGroup
        can :manage, Merchant
        can :manage, AffiliateProgram
      end
  end



end
