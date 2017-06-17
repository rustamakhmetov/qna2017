class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, presence: true

  accepts_nested_attributes_for :attachments

  default_scope { order(accept: :desc, id: :asc) }

  def accept!
    transaction do
      question.answers.update_all(accept: false)
      update!(accept: true)
    end
  end
end
