require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #create' do
    sign_in_user

    let!(:question) { create(:question) }
    subject { post :create, params: { question_id: question, format: :js } }

    it 'assigns user to @user' do
      subject
      expect(assigns("subscription").user).to eq @user
    end

    it 'assigns question to @question' do
      subject
      expect(assigns("subscription").question).to eq question
    end

    it 'saves the new subscription to database' do
      expect { subject }.to change(Subscription, :count).by(1)
    end

    it 'render create view' do
      subject
      expect(response).to render_template :create
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let!(:question) { create(:question, user: @user) }
    let!(:subscription) { @user.subscribe(question) }
    subject { delete :destroy, params: { id: subscription.id, format: :js } }

    it 'assigns subscription to @subscription' do
      subject
      expect(assigns("subscription")).to eq subscription
    end

    it 'delete subscription from database' do
      expect { subject }.to change(Subscription, :count).by(-1)
    end

    it 'render destroy view' do
      subject
      expect(response).to render_template :destroy
    end
  end
end

