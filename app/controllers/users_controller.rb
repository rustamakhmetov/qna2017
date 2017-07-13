class UsersController < ApplicationController
  before_action :load_user, only: [:finish_signup]

  def finish_signup
    if request.patch? && user_params[:email]
      user_status = @user.update_params(user_params)
      if user_status
        case user_status[:status]
          when :new
            sign_in_and_redirect user_status[:user], event: :authentication
          when :existing
            sign_in user_status[:user]
            redirect_to root_path, notice: t("devise.sessions.signed_in")
        end
      end
    end
  end

  private

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end
end