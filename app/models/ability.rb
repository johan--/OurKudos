class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new
      if user.has_role?(:admin)
        can :manage, :all
      elsif user.has_role?("kudo editor")
        can :manage, [KudoFlag]
      elsif user.has_role?("gift editor")
        can :manage, [Gift, GiftGroup, Merchant, AffiliateProgram]
      end
  end



end
