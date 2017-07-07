require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    subject { get :index }

    it 'populates an array of all questions' do
      questions = create_list(:question, 2)
      subject
      expect(assigns(:questions)).to eq questions
    end

    it 'renders index view' do
      subject
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: {id: question} }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns the votes to @question.votes' do
      user = create(:user)
      vote = create(:vote, user: user, votable: question, value: 1)
      expect(assigns(:question).votes).to eq [vote]
    end

    it 'build a new Attachment to @answer.attachments' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
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

    it 'build a new Attachment to @question.attachments' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
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

      it 'current user link to the new question' do
        post 'create', params: { question: attributes_for(:question) }
        expect(assigns("question").user).to eq @user
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
      let!(:title) { question.title }
      let!(:body) { question.body }

      it 'does not change question attributes' do
        patch :update, params: {id: question, question: attributes_for(:invalid_question)}
        question.reload
        expect(question.title).to eq title
        expect(question.body).to eq body
      end

      it 're-renders edit view' do
        patch :update, params: {id: question, question: attributes_for(:invalid_question)}
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    it 'only author can be delete question' do
      question = create(:question, user: @user)
      expect {delete :destroy, params: {id: question}}.to change(Question, :count).by(-1)
    end

    it 'user can not delete question of other author' do
      question1 = create(:question, user: create(:user))
      expect {delete :destroy, params: {id: question1}}.to_not change(Question, :count)
    end

    it 'redirects to index view' do
      delete :destroy, params: {id: question}
      expect(response).to redirect_to questions_path
    end
  end

  it_behaves_like "voted" do
    let(:object) { question }
  end

end
