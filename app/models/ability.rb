class Ability
  include CanCan::Ability

  def initialize(user)

    # Anonymous user functions
    can :read, Forum
    can :children, Forum
    can :search, Forum
    can :all_posts, Forum

    can :read, Post    

    can :read, Comment
    ###

    # Basic forum functions for verified users
    if user.sms_confirmed or user.admin?
      can :create, Post
      can :vote, Post
      can :create, Comment
      can :vote, Comment
    end
    ###

    # Moderation
    if user.admin? or user.moderator?
      can :approve, Post
    end
    ###

    # Admin
    if user.admin?
      can :search, User
      can :verify, User
      can :promote, User
      can :demote, User
      can :delete, User
    end
    ###
    
  end
end
