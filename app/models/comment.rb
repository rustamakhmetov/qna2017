class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true, optional: true

  validates :commentable_id, :commentable_type, :body, presence: true
end
