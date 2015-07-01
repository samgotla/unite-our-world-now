class Ability
  include CanCan::Ability

  def initialize(user)
    can :post_topic if user.sms_confirmed
    
    can :read, Forum
    can :children, Forum
    can :search, Forum
    can :all_posts, Forum

    can :read, Post
    can :create, Post

    can :read, Comment
    can :create, Comment
  end
end
