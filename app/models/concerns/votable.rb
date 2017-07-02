module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up!(user)
    unless user&.author_of?(self)
      if vote_up_exists?(user)
        vote_reset!(user)
      else
        vote_reset!(user) if vote_down_exists?(user)
        votes.create(user: user, value: 1)
      end
    end
  end

  def vote_down!(user)
    unless user&.author_of?(self)
      if vote_down_exists?(user)
        vote_reset!(user)
      else
        vote_reset!(user) if vote_up_exists?(user)
        votes.create(user: user, value: -1)
      end
    end
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
end
