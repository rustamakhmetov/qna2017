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
          expect(response.body).to include_json(
                                       object_klass: object.class.name.downcase,
                                       object_id: object.id,
                                       count: object.votes.count
                                   )
        end
      end

      context "vote down" do
        it 'assigns the requested votable to object' do
          patch :vote_down, params: {id: object, format: :json}
          expect(assigns(:votable)).to eq object
        end

        it 'change to down -1 vote' do
          vote = create(:vote, votable: object)
          expect { patch :vote_down, params: {id: object, format: :json} }.to change(Vote, :count).by(-1)
        end

        it 'empty votes to change to down -1 vote' do
          expect { patch :vote_down, params: {id: object, format: :json} }.to_not change(Vote, :count)
        end

        it 'render vote to json' do
          patch :vote_down, params: {id: object, format: :json}
          expect(response).to be_success
          expect(response.body).to include_json(
                                       object_klass: object.class.name.downcase,
                                       object_id: object.id,
                                       count: object.votes.count
                                   )
        end
      end
    end

    context "Author of object can't vote for object" do
      let!(:object1) { create(object.class.name.downcase.to_sym, user: @user) }

      it 'to not change vote up' do
        expect { patch :vote_up, params: {id: object1, format: :json} }.to_not change(Vote, :count)
      end

      it 'to not change vote down' do
        object1.votes << create(:vote, user: @user)
        expect { patch :vote_down, params: {id: object1, format: :json} }.to_not change(Vote, :count)
      end
    end
  end
end