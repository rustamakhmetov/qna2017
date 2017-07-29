class Answer < ApplicationRecord
  include Votable

  belongs_to :user
  belongs_to :question
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  default_scope { order(accept: :desc, id: :asc) }

  after_create :new_answer

  def accept!
    transaction do
      question.answers.where('id != ?', id).update_all(accept: false)
      update!(accept: true)
    end
  end

  private

  def new_answer
    NotifySubscribersJob.perform_later(self)
  end
end
