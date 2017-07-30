module MailerHelpers

  def mail(method, *arguments)
    @_mail_called = true
    @_mailer_method = method
    @_mailer_arguments = arguments
  end

  def mailer
    raise "You must use mail(:method_name) before calling :mailer" unless @_mail_called
    @mailer ||= described_class.new.tap do |mailer|
      mailer.process(@_mailer_method, *@_mailer_arguments)
    end
  end

  def response
    raise "You must use mail(:method_name) before calling :response" unless @_mail_called
    @response ||= mailer.message
  end

  def assigns(method)
    raise "You must use mail(:method_name) before calling :assigns" unless @_mail_called
    mailer.view_assigns.with_indifferent_access[method]
  end
end