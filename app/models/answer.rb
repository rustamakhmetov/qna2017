class Answer < ApplicationRecord
  include Votable

  belongs_to :user
  belongs_to :question
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  default_scope { order(accept: :desc, id: :asc) }

  after_create :calculate_rating

  def accept!
    transaction do
      question.answers.where('id != ?', id).update_all(accept: false)
      update!(accept: true)
    end
  end

  private

  def calculate_rating
    Reputation.delay.calculate(self)
  end
end
