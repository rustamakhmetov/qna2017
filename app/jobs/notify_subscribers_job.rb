class NotifySubscribersJob < ApplicationJob
  queue_as :default

  def perform(object)
    question = object.is_a?(Question) ? object : object.question
    question.subscriptions.find_each.each do |subscription|
      if object.is_a? Question
        DailyMailer.notify_update_question(subscription.user, object).deliver_later
      else
        DailyMailer.notify_new_answer(subscription.user, object).deliver_later
      end
    end
  end
end
