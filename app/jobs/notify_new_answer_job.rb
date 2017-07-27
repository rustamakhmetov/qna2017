class NotifyNewAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    DailyMailer.notify_new_answer(answer).deliver_later
  end
end
