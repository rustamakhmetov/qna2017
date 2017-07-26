class DailyMailer < ApplicationMailer
  def digest(user, questions)
    @questions = questions
    mail( to: user.email,
          subject: t('daily_mailer.digest.subject'))
  end
end
