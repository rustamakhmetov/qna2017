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

end
