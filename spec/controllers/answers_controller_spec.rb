require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }

  describe 'GET #index' do
    before { get :index, params: {question_id: question} }

    it 'populates an array of all answers' do
      answers = create_list(:answer, 2)
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: {id: answer} }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new, params: {question_id: question} }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: {id: answer} }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:question) { create(:question) }

      it 'saves the new answer to database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }}.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to answer_path(assigns(:answer))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }}.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: {id: answer, answer: {body: 'Body new'}}
        expect(assigns(:answer)).to eq answer
      end

      it 'change answer attributes' do
        patch :update, params: {id: answer, answer: {body: 'Body new'}}
        answer.reload
        expect(answer.body).to eq 'Body new'
      end

      it 'redirects to the updated answer' do
        patch :update, params: {id: answer, answer: {body: 'Body new'}}
        expect(response).to redirect_to answer
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        patch :update, params: {id: answer, answer: attributes_for(:invalid_answer).merge(question_id: nil)}
        answer.reload
        expect(answer.body).to eq 'MyString'
        expect(answer.question).to_not eq nil
      end

      it 're-renders edit view' do
        patch :update, params: {id: answer, answer: attributes_for(:invalid_answer).merge(question_id: nil)}
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes answer' do
      answer
      expect {delete :destroy, params: {id: answer}}.to change(Answer, :count).by(-1)
    end

    it 'redirects to index view' do
      delete :destroy, params: {id: answer}
      expect(response).to redirect_to question_answers_path(answer.question_id)
    end
  end

end
