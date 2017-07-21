require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    it_behaves_like "API authenticable" do
      let(:url) { "/api/v1/questions" }
    end

    context 'authorized' do
      let!(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token }}

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("0/short_title")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET /show' do

    let!(:question) { create(:question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context "authorized" do
      let!(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:attachment) { create(:attachment, attachable: question) }
      let!(:comments) { create_list(:comment, 2, commentable: question )}

      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token }}

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end

      context 'attachments' do
        it 'returns list' do
          expect(response.body).to have_json_size(1).at_path("attachments")
        end

        it "contains url" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/url")
        end
      end

      context "comments" do
        it 'returns list' do
          expect(response.body).to have_json_size(2).at_path("comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "object contains #{attr}" do
            comment = comments.first
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end
    end
  end

  describe "POST /create" do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post "/api/v1/questions", params: { question: attributes_for(:question), format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post "/api/v1/questions", params: { question: attributes_for(:question), format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context "authorized as user" do
      let!(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context "with valid attributes" do
        let!(:question_params) { attributes_for(:question) }

        subject { post "/api/v1/questions", params: { question: question_params, format: :json, access_token: access_token.token }}

        it 'returns 200 status' do
          subject
          expect(response).to be_success
        end

        it 'saves the new question to database' do
          expect { subject }.to change(Question, :count).by(1)
        end

        %w(title body).each do |attr|
          it "question object contains #{attr}" do
            subject
            expect(response.body).to be_json_eql(question_params[attr.to_sym].to_json).at_path("#{attr}")
          end
        end
      end

      context "with invalid attributes" do
        let!(:invalid_question_params) { attributes_for(:invalid_question) }

        subject { post "/api/v1/questions", params: { question: invalid_question_params, format: :json, access_token: access_token.token }}

        it 'returns 422 status' do
          subject
          expect(response.status).to eq 422
        end

        it 'does not save question to database' do
          expect { subject }.to_not change(Question, :count)
        end

        %w(title body).each do |attr|
          it "reponse contains errors for #{attr}" do
            subject
            expect(response.body).to be_json_eql("can't be blank".to_json).at_path("errors/#{attr}/0")
          end
        end
      end
    end

    context "authorized as guest" do
      let(:access_token) { create(:access_token, resource_owner_id: nil) }
      let!(:question_params) { attributes_for(:question) }

      subject { post "/api/v1/questions", params: { question: question_params, format: :json, access_token: access_token.token }}

      it 'returns does not success status' do
        subject
        expect(response).to_not be_success
      end

      it 'does not saved question to database' do
        expect { subject }.to_not change(Question, :count)
      end
    end
  end
end
