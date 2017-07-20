require "rails_helper"

shared_examples_for "voted" do
  describe 'PATCH #vote' do
    sign_in_user

    context "User vote for object" do

      context "vote up" do
        it 'assigns the requested question to @question' do
          patch :vote_up, params: {id: object, format: :json}
          expect(assigns(:votable)).to eq object
        end

        it 'change to up +1 vote' do
          expect { patch :vote_up, params: {id: object, format: :json} }.to change(Vote, :count).by(1)
        end

        it 'render vote to json' do
          patch :vote_up, params: {id: object, format: :json}
          expect(response).to be_success

          expect(response.body).to be_json_eql(object.class.name.downcase.to_json).at_path("object_klass")
          expect(response.body).to be_json_eql(object.id).at_path("object_id")
          expect(response.body).to be_json_eql(object.votes.count).at_path("count")
        end
      end

      context "vote down" do
        it 'assigns the requested votable to object' do
          patch :vote_down, params: {id: object, format: :json}
          expect(assigns(:votable)).to eq object
        end

        it 'change to down -1 vote' do
          vote = create(:vote, votable: object, value: 1)
          patch :vote_down, params: {id: object, format: :json}
          expect(object.vote_rating).to eq 0
          expect(object.votes.count).to eq 2
        end

        it 'empty votes to change to down -1 vote' do
          expect { patch :vote_down, params: {id: object, format: :json} }.to change(Vote, :count).by(1)
        end

        it 'render vote to json' do
          patch :vote_down, params: {id: object, format: :json}
          expect(response).to be_success
          expect(response.body).to be_json_eql(object.class.name.downcase.to_json).at_path("object_klass")
          expect(response.body).to be_json_eql(object.id).at_path("object_id")
          expect(response.body).to be_json_eql(object.vote_rating).at_path("count")
        end
      end
    end

    context "Author of object can't vote for object" do
      let!(:object1) { create(object.class.name.downcase.to_sym, user: @user) }

      it 'to not change vote up' do
        expect { patch :vote_up, params: {id: object1, format: :json} }.to_not change(Vote, :count)
      end

      it 'to not change vote down' do
        object1.votes << create(:vote, user: @user, votable: object1, value: -1)
        expect { patch :vote_down, params: {id: object1, format: :json} }.to_not change(Vote, :count)
      end
    end

    context 'Authenticate user vote up for object only one time' do
      it 'to vote up' do
        expect do
          patch :vote_up, params: {id: object, format: :json}
          patch :vote_up, params: {id: object, format: :json}
        end.to_not change(Vote, :count)
      end

      it 'to vote down' do
        object.votes << create(:vote, user: @user, votable: object, value: 1)
        object.votes << create(:vote, user: create(:user), votable: object, value: 1)
        expect(object.vote_rating).to eq 2
        patch :vote_down, params: {id: object, format: :json}
        patch :vote_down, params: {id: object, format: :json}
        expect(object.vote_rating).to eq 1
        expect(object.votes.count).to eq 1
      end
    end

    context 'Authenticated user can cancel' do
      it 'vote up' do
        expect do
          patch :vote_up, params: {id: object, format: :json}
          patch :vote_up, params: {id: object, format: :json}
        end.to_not change(Vote, :count)
      end

      it 'vote down' do
        expect do
          patch :vote_down, params: {id: object, format: :json}
          patch :vote_down, params: {id: object, format: :json}
        end.to_not change(Vote, :count)
      end
    end
  end
end