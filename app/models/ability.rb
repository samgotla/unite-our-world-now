class Ability
  include CanCan::Ability

  def initialize(user)
    if user.sms_confirmed or user.admin?
      can :post_topic
      can :create, Post
      can :upvote, Post
      can :downvote, Post
    end
    
    can :read, Forum
    can :children, Forum
    can :search, Forum
    can :all_posts, Forum

    can :read, Post    

    can :read, Comment
    can :create, Comment

    if user.admin? or user.moderator?
      can :search, User
    end
  end
end
