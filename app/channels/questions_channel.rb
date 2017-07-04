class QuestionsChannel < ApplicationCable::Channel
  def follow(data)
    #Rails.logger.info(data)
    #transmit data
    stream_from "questions"
  end
end