class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new
    if user.has_role? :admin
      can :manage, :all
    end
  end



end