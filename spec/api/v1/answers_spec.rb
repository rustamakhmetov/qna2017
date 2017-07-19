require 'rails_helper'

describe 'Answers API' do
  let!(:question) { create(:question) }

  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:answers) { create_list(:answer, 2, question: question) }

      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token }}

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2)
      end

      %w(id body accept rating created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          answer = answers.first
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    let!(:answer) { create(:answer) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:attachment) { create(:attachment, attachable: answer) }
      let!(:comments) { create_list(:comment, 2, commentable: answer )}


      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token }}

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id body accept rating created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{attr}")
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
        post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context "authorized as user" do
      let!(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:question) { create(:question) }

      context "with valid attributes" do
        let!(:answer_params) { attributes_for(:answer) }

        subject { post "/api/v1/questions/#{question.id}/answers", params: { answer: answer_params, format: :json, access_token: access_token.token }}

        it 'returns 200 status' do
          subject
          expect(response).to be_success
        end

        it 'saves the new answer to database' do
          expect { subject }.to change(Answer, :count).by(1)
        end

        %w(body).each do |attr|
          it "answer object contains #{attr}" do
            subject
            expect(response.body).to be_json_eql(answer_params[attr.to_sym].to_json).at_path("#{attr}")
          end
        end
      end

      context "with invalid attributes" do
        let!(:invalid_answer_params) { attributes_for(:invalid_answer) }

        subject { post "/api/v1/questions/#{question.id}/answers", params: { answer: invalid_answer_params, format: :json, access_token: access_token.token }}

        it 'returns 422 status' do
          subject
          expect(response.status).to eq 422
        end

        it 'does not save question to database' do
          expect { subject }.to_not change(Answer, :count)
        end

        %w(body).each do |attr|
          it "reponse contains errors for #{attr}" do
            subject
            expect(response.body).to be_json_eql("can't be blank".to_json).at_path("errors/#{attr}/0")
          end
        end
      end
    end

    context "authorized as guest" do
      let(:access_token) { create(:access_token, resource_owner_id: nil) }
      let!(:answer_params) { attributes_for(:question) }

      subject { post "/api/v1/questions/#{question.id}/answers", params: { answer: answer_params, format: :json, access_token: access_token.token }}

      it 'returns does not success status' do
        subject
        expect(response).to_not be_success
      end

      it 'does not saved answer to database' do
        expect { subject }.to_not change(Answer, :count)
      end
    end
  end
end
