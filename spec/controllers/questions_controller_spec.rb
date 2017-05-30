require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    before { get :index }

    it 'populates an array of all questions' do
      questions = create_list(:question, 2)
      expect(assigns(:questions)).to eq questions
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: {id: question} }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user

    before { get :edit, params: {id: question} }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new question to database' do
        expect { post :create, params: { question: attributes_for(:question) }}.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) }}.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: {id: question, question: {title:'Title new', body: 'Body new'}}
        expect(assigns(:question)).to eq question
      end

      it 'change question attributes' do
        patch :update, params: {id: question, question: {title:'Title new', body: 'Body new'}}
        question.reload
        expect(question.title).to eq 'Title new'
        expect(question.body).to eq 'Body new'
      end

      it 'redirects to the updated question' do
        patch :update, params: {id: question, question: {title:'Title new', body: 'Body new'}}
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not change question attributes' do
        patch :update, params: {id: question, question: attributes_for(:invalid_question)}
        question.reload
        expect(question.title).to eq 'Question 1'
        expect(question.body).to eq 'Body 1'
      end

      it 're-renders edit view' do
        patch :update, params: {id: question, question: attributes_for(:invalid_question)}
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    it 'deletes question' do
      question
      expect {delete :destroy, params: {id: question}}.to change(Question, :count).by(-1)
    end

    it 'redirects to index view' do
      delete :destroy, params: {id: question}
      expect(response).to redirect_to questions_path
    end
  end
end
