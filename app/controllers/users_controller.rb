class UsersController < ApplicationController
  before_action :load_user, only: [:finish_signup]

  def finish_signup
    if request.patch? && user_params[:email]
      email = user_params[:email]
      user = User.find_by_email(email)
      if user
        user.authorizations << @user.authorizations
        user.save
        @user.destroy
        sign_in user
        redirect_to root_path, notice: t("devise.sessions.signed_in")
      else
        if @user.update(user_params.merge(confirmed_at: nil))
          @user.send_confirmation_instructions
          sign_in_and_redirect @user, event: :authentication
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