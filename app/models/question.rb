class Question < ApplicationRecord
  include Votable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  after_update :update_question
  after_create :subscribe_question, if: :persisted?

  def self.digest
    Question.all.where("created_at >= ?", Time.zone.now.beginning_of_day)
  end

  private

  def update_question
    NotifySubscribersJob.perform_later(self)
  end

  def subscribe_question
    self.user.subscribe(self)
  end
end
