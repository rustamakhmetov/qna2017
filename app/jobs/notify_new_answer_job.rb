class NotifyNewAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    DailyMailer.new_answer(answer).deliver_later
  end
end
