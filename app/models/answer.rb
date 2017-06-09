class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :body, presence: true

  def accept!
    transaction do
      question.answers.update_all(accept: false)
      update!(accept: true)
    end
  end
end
