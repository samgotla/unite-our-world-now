class Ability
  include CanCan::Ability

  def initialize(user)
    can :post_topic if user.sms_confirmed
    can :read, Forum
  end
end
