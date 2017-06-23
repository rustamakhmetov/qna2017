require "rails_helper"

shared_examples_for "voted" do
  describe 'PATCH #vote' do
    sign_in_user

    context "User vote for question" do

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
  end
end