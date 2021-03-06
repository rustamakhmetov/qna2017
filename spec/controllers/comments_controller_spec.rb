require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:question) { create(:question) }
  # let(:comment) { create(:comment, ) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      subject { post :create, params: { question_id: question.id, comment: attributes_for(:comment) }, format: :json }

      it 'assigns the requested object to @commentable' do
        subject
        expect(assigns(:commentable)).to eq question
      end

      it 'saves the new comment to database' do
        expect { subject }.to change(question.comments, :count).by(1)
      end

      it 'current user link to the new comment' do
        subject
        expect(assigns("comment").user).to eq @user
      end

      it 'render template create' do
        subject
        expect(response).to render_template "comments/create"
        comment = question.comments.first
        expect(response.body).to be_json_eql(@user.id).at_path("user_id")
        expect(response.body).to be_json_eql(comment.id).at_path("id")
        expect(response.body).to be_json_eql(question.id).at_path("commentable_id")
        expect(response.body).to be_json_eql(question.class.name.to_json).at_path("commentable_type")
        expect(response.body).to be_json_eql(comment.body.to_json).at_path("body")
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question.id, comment: attributes_for(:invalid_comment), format: :json }}.to_not change(Answer, :count)
      end

      it 'render template create' do
        post :create, params: { question_id: question.id, comment: attributes_for(:invalid_comment), format: :json }
        expect(response).to have_http_status(422)
      end
    end
  end
end