class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true, optional: true

  validates :votable_id, :votable_type, presence: true
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :value, inclusion: [1, -1]

  before_create :update_rating
  before_destroy :update_rating_destroy

  private

  def update_rating
    votable.increment!(:rating, value)
  end

  def update_rating_destroy
    votable.decrement!(:rating, value)
  end
end
