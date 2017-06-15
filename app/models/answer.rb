class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :body, presence: true

  default_scope { order(accept: :desc, id: :asc) }

  def accept!
    transaction do
      question.answers.where('id != ?', id).update_all(accept: false)
      update!(accept: true) unless accept
    end
  end
end
