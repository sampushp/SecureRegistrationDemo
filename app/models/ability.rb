class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    elsif user.user?
      cannot :manage, SecretCode
      cannot [:index, :destroy, :update], User
    end
  end
end
