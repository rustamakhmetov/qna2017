class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    digest = Question.digest.map { |question| { title: question.title, url: question_url(question) }}
    User.all.find_each.each do |user|
      DailyMailer.digest(user, digest).deliver_later
    end
  end
end
