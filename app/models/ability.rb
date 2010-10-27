class Ability

  include CanCan::Ability

  def initialize(user)
    if user && !user.admin?   # regular users

      can :read, :all

      can :manage, Review, :user_id => user.id
      can :manage, ReviewComment, :user_id => user.id
      can :manage, Tagging, :user_id => user.id
      can :manage, User, :id => user.id

    elsif user && user.admin? # admins

      can :manage, :all

    else                      # people that arent signed in

      can :read, :all

      can :create, User
      can :thanks, User
      can :activate, User

    end
  end

end
