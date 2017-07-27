class DailyMailer < ApplicationMailer

  def digest(user, questions)
    @questions = questions
    mail( to: user.email,
          subject: t('daily_mailer.digest.subject'))
  end

  def notify_new_answer(user, answer)
    @answer = answer
    @question = answer.question
    mail( to: user.email,
          subject: "New answer for question '#{@question.title}'")
  end

  def notify_update_question(user, question)
    @question = question
    mail( to: user.email,
          subject: "The content of the question '#{question.title}' has been updated")
  end
end
