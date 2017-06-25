class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true, optional: true

  validates :votable_id, :votable_type, presence: true
  validates :value, inclusion: [1, -1]
end
