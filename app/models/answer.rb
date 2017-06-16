class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  has_many :attachments, as: :attachmentable

  validates :body, presence: true

  accepts_nested_attributes_for :attachments

  default_scope { order(accept: :desc, id: :asc) }

  def accept!
    transaction do
      question.answers.where('id != ?', id).update_all(accept: false)
      update!(accept: true) unless accept
    end
  end
end
