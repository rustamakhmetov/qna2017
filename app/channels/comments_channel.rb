class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "question#{params[:questionId]}-comments"
  end
end