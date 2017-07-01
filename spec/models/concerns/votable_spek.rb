require 'rails_helper'

shared_examples_for "votable" do
  let!(:model) { described_class }
  let!(:user) { create(:user) }

  describe '#votes' do
    let!(:object) { create(model.to_s.underscore.to_sym) }

    it 'vote up' do
      expect { object.vote_up!(user) }.to change(Vote, :count).by(1)
    end

    it 'vote down' do
      expect { object.vote_down!(user) }.to change(Vote, :count).by(1)
    end

    it 'vote rating' do
      object.vote_up!(user)
      object.vote_down!(user)
      expect(object.vote_rating).to eq -1
    end

    it 'vote up exists' do
      object.vote_up!(user)
      expect(object.vote_up_exists?(user)).to eq true
      expect(object.vote_exists?(user)).to eq true
    end

    it 'vote down exists' do
      object.vote_down!(user)
      expect(object.vote_down_exists?(user)).to eq true
      expect(object.vote_exists?(user)).to eq true
    end

    it 'vote reset' do
      object.vote_up!(user)
      object.vote_reset!(user)
      expect(object.vote_rating).to eq 0
    end

    describe 'Author of question' do
      it 'can not vote up for him' do
        expect { object.vote_up!(object.user) }.to_not change(Vote, :count)
      end

      it 'can not vote down for him' do
        expect { object.vote_down!(object.user) }.to_not change(Vote, :count)
      end
    end

    describe "Authenticate user vote for object only one time" do
      it "vote up" do
        expect do
          object.vote_up!(user)
          object.vote_up!(user)
        end.to change(Vote, :count).by(1)
      end

      it "vote down" do
        expect do
          object.vote_down!(user)
          object.vote_down!(user)
        end.to change(Vote, :count).by(1)
      end

      it 'vote down after vote up' do
        object.vote_up!(user)
        expect(object.vote_up_exists?(user)).to eq true
        object.vote_down!(user)
        expect(object.vote_up_exists?(user)).to eq false
        expect(object.vote_down_exists?(user)).to eq true
      end

      it 'vote up after vote down' do
        object.vote_down!(user)
        expect(object.vote_down_exists?(user)).to eq true
        object.vote_up!(user)
        expect(object.vote_down_exists?(user)).to eq false
        expect(object.vote_up_exists?(user)).to eq true
      end

      it "can't cancel someone else's vote" do
        object.vote_down!(create(:user))
        object.vote_up!(user)
        expect(object.vote_rating).to eq 0
        object.vote_reset!(user)
        expect(object.vote_rating).to eq -1
      end
    end
  end
end
