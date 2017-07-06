class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "question#{params[:questionId]}-answers"
  end
end