class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user&.email_verified?
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can [:update, :destroy], [Question, Answer, Comment], user: user
    can :accept, Answer do |answer|
      !answer.accept && @user.author_of?(answer.question) && !@user.author_of?(answer)
    end
    can [:vote_up, :vote_down], [Question, Answer] do |model|
      !@user.author_of?(model)
    end
    can :edit, [Question, Answer]
    can :manage, Vote
    can :manage, Attachment do |attach|
      @user.author_of?(attach.attachable)
    end
    can :manage, Authorization
    #can :manage, :profile
  end

  def admin_abilities
    can :manage, :all
  end
end
