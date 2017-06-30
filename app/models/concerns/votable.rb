module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up!(user)
    vote_reset!(user) if vote_down_exists?(user)
    votes.create(user: user, value: 1) unless user&.author_of?(self) || vote_up_exists?(user)
  end

  def vote_down!(user)
    vote_reset!(user) if vote_up_exists?(user)
    votes.create(user: user, value: -1) unless user&.author_of?(self) || vote_down_exists?(user)
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
    votes.sum(:value)
  end
end
