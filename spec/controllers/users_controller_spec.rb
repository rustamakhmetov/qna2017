require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { create(:user) }

  describe "GET #finish_signup" do
    before do
      sign_in user
      get :finish_signup, params: { id: user.id }
    end

    it 'assigns the requested user to @user' do
      expect(assigns(:user)).to eq user
    end

    it 'render finish signup form' do
      expect(response).to render_template :finish_signup
    end
  end

  describe "PATCH #finish_signup" do
    before do
      sign_in user
      patch :finish_signup, params: { id: user.id, user: { email: "new@test.com" } }
    end

    it 'assigns the requested user to @user' do
      expect(assigns(:user)).to eq user
    end

    it 'change user attributes' do
      user.reload
      expect(user.email).to eq "new@test.com"
    end

    it 'redirect to confirmation email path' do
      expect(response).to redirect_to new_user_session_path
    end
  end

end