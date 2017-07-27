class DailyMailer < ApplicationMailer
  def digest(user, questions)
    @questions = questions
    mail( to: user.email,
          subject: t('daily_mailer.digest.subject'))
  end

  def new_answer(answer)
    @answer = answer
    @question = answer.question
    mail( to: answer.question.user.email,
          subject: "New answer for question '#{@question.title}'")
  end
end
