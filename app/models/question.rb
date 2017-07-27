class Question < ApplicationRecord
  include Votable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  def self.digest
    Question.all.where("created_at >= ?", Time.zone.now.beginning_of_day)
  end
end
