class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "questions/#{params[:questionId]}/answers"
  end
end