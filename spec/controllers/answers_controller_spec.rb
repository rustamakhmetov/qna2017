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
      expect {delete :destroy, params: {id: answer, format: :js}}.to change(Answer, :count).by(-1)
    end

    it 'user can not delete answer of other author' do
      answer1 = create(:answer, user: create(:user), question: answer.question)
      expect {delete :destroy, params: {id: answer1, format: :js}}.to_not change(Answer, :count)
    end

    it 'redirects to question view' do
      delete :destroy, params: {id: answer, format: :js}
      expect(response).to render_template :destroy
    end
  end

  describe 'PATCH #accept' do
    sign_in_user

    context "Author of question" do
      let!(:question) { create(:question, user: @user) }
      let!(:answer) { create(:answer, question: question) }

      it 'assigns the requested answer to @answer' do
        patch :accept, params: {id: answer, format: :js}
        expect(assigns(:answer)).to eq answer
      end

      it 'change answer accept attribute' do
        expect(answer.accept).to eq false
        patch :accept, params: {id: answer, format: :js}
        answer.reload
        expect(answer.accept).to eq true
      end

      it 'reset accept field of other answers from the question' do
        answer2 = create(:answer, question: question, accept: true)
        answer3 = create(:answer, question: question, accept: true)

        patch :accept, params: {id: answer, format: :js}
        answer.reload
        answer2.reload
        answer3.reload
        expect(answer.accept).to eq true
        expect(answer2.accept).to eq false
        expect(answer3.accept).to eq false
      end

      it 'render accept template' do
        patch :accept, params: {id: answer, format: :js}
        expect(response).to render_template :accept
      end
    end

    context "Non-author of question" do
      it 'current user is not the author of the question' do
        expect(@user).to_not eq question.user
      end

      it 'assigns the requested answer to @answer' do
        patch :accept, params: {id: answer, format: :js}
        expect(assigns(:answer)).to eq answer
      end

      it 'not change answer accept attribute' do
        expect(answer.accept).to eq false
        patch :accept, params: {id: answer, format: :js}
        answer.reload
        expect(answer.accept).to eq false
      end

      it 'not reset accept field of other answers from the question' do
        answer2 = create(:answer, question: question, accept: true)
        answer3 = create(:answer, question: question, accept: true)

        patch :accept, params: {id: answer, format: :js}
        answer.reload
        answer2.reload
        answer3.reload
        expect(answer.accept).to eq false
        expect(answer2.accept).to eq true
        expect(answer3.accept).to eq true
      end

      it 'render accept template' do
        patch :accept, params: {id: answer, format: :js}
        expect(response).to render_template :accept
      end
    end
  end
end
