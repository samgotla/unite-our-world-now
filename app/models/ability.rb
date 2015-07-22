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

    # Normal user functions
    can :edit, Post, user_id: user.id
    can :update, Post, user_id: user.id
    can :destroy, Post, user_id: user.id

    can :edit, Comment, user_id: user.id
    can :update, Comment, user_id: user.id
    can :destroy, Comment, user_id: user.id
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
      can :destroy, User

      can :destroy, Post
      can :destroy, Comment
    end
    ###
    
  end
end
