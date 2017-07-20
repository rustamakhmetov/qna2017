require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    it_behaves_like "API authenticable" do
      let(:url) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token }}

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET /index' do
    it_behaves_like "API authenticable" do
      let(:url) { '/api/v1/profiles' }
    end

    context 'authorized' do
      let!(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:user1) { create(:user) }
      let!(:user2) { create(:user) }

      before { get '/api/v1/profiles', params: { format: :json, access_token: access_token.token }}

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'list size is 2' do
        expect(response.body).to have_json_size(2)
      end

      it 'me not exists' do
        expect(response.body).to_not include_json(me.to_json)
      end

      it 'user1 exists' do
        expect(response.body).to include_json(user1.to_json)
      end

      it 'user2 exists' do
        expect(response.body).to include_json(user2.to_json)
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(user1.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          result = JSON(response.body)[0].to_json
          expect(result).to_not have_json_path(attr)
        end
      end
    end
  end
end