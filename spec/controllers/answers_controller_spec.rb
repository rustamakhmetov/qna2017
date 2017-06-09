require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      let(:question) { create(:question) }

      it 'saves the new answer to database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'current user link to the new answer' do
        post 'create', params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(assigns("answer").user).to eq @user
      end

      it 'render template create' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js }}.to_not change(Answer, :count)
      end

      it 'render template create' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'with valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: {id: answer, answer: {body: 'Body new'}, format: :js}
        expect(assigns(:answer)).to eq answer
      end

      it 'change answer attributes' do
        patch :update, params: {id: answer, answer: {body: 'Body new'}, format: :js}
        answer.reload
        expect(answer.body).to eq 'Body new'
      end

      it 'render updated template' do
        patch :update, params: {id: answer, answer: {body: 'Body new'}, format: :js}
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        body = answer.body
        patch :update, params: {id: answer, answer: attributes_for(:invalid_answer).merge(question_id: nil), format: :js}
        answer.reload
        expect(answer.body).to eq body
        expect(answer.question).to_not eq nil
      end

      it 'render updated template' do
        patch :update, params: {id: answer, answer: attributes_for(:invalid_answer).merge(question_id: nil), format: :js}
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    it 'deletes answer of author' do
      answer = create(:answer, user: @user)
      expect {delete :destroy, params: {id: answer}}.to change(Answer, :count).by(-1)
    end

    it 'user can not delete answer of other author' do
      answer1 = create(:answer, user: create(:user), question: answer.question)
      expect {delete :destroy, params: {id: answer1}}.to_not change(Answer, :count)
    end

    it 'redirects to question view' do
      delete :destroy, params: {id: answer}
      expect(response).to redirect_to question_path(answer.question_id)
    end
  end

end
