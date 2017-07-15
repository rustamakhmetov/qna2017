require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  include ApplicationHelper
  protect_from_forgery with: :exception

  before_action :ensure_signup_complete, only: [:new, :create, :update, :destroy]

  check_authorization :unless => :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  def ensure_signup_complete
    # Убеждаемся, что цикл не бесконечный
    return if action_name == 'finish_signup' || (controller_name=="sessions" && action_name=="destroy")
    Rails.logger.info("controller name: #{controller_name}")
    Rails.logger.info("action name: #{action_name}")

    # Редирект на адрес 'finish_signup' если пользователь
    # не подтвердил свою почту
    if current_user&.temp_email?
      redirect_to finish_signup_path(current_user)
    end
  end
end
