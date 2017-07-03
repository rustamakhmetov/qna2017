module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up!(user)
    vote_change(user, :up)
  end

  def vote_down!(user)
    vote_change(user, :down)
  end

  def vote_up_exists?(user)
    votes.exists?(user_id: user.id, value: 1)
  end

  def vote_down_exists?(user)
    votes.exists?(user_id: user.id, value: -1)
  end

  def vote_exists?(user)
    votes.exists?(user_id: user.id)
  end

  def vote_reset!(user)
    votes.where(user_id: user.id).destroy_all
  end

  def vote_rating
    reload_attribute(:rating)
    rating
  end

  private

  def reload_attribute(attr)
    value = self.class.where(:id=>id).select(attr).first[attr]
    self[attr] = value
  end

  def vote_change(user, act)
    unless user&.author_of?(self)
      vote_act = vote_action(user)
      vote_reset!(user)
      if vote_act!=act
        votes.create(user: user, value: (act==:up ? 1 : -1))
      end
    end
  end

  def vote_action(user)
    vote = votes.where(user_id: user.id).first
    (vote.value==1 ? :up : :down) if vote
  end
end
