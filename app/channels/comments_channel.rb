class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "questions/#{params[:questionId]}/comments"
  end
end