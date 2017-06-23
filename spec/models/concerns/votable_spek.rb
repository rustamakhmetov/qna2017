require 'rails_helper'

shared_examples_for "votable" do
  let(:model) { described_class }
  let!(:user) { create(:user) }
  let(:vote) { create(:vote, user: user) }
  
  it '#votes' do
    question = create(model.to_s.underscore.to_sym)
    question.votes << vote
    expect(question.votes).to match_array(vote)
  end
end
