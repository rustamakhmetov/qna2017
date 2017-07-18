class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :accept, :rating, :created_at, :updated_at

  has_many :attachments
  has_many :comments
end
