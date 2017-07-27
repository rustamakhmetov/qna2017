require 'rails_helper'

describe Question do
  it { should belong_to :user}
  it { should have_many(:answers).dependent(:destroy)}
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should validate_presence_of :title}
  it { should validate_presence_of :body}
  it { should accept_nested_attributes_for :attachments }

  describe ".digest" do
    let!(:questions_today) { create_list(:question, 2) }
    let!(:question_yesterday) { create(:question, created_at: 1.day.ago) }

    it 'return all question in today' do
      expect(Question.all.size).to eq 3
      expect(Question.digest).to match_array(questions_today)
    end
  end

  it_behaves_like "votable"

  describe "send notifications to subscribers" do
    let(:question) { create(:question) }

    it 'when updating a question' do
      expect(NotifySubscribersJob).to receive(:perform_later).with(question).and_call_original
      question.update(body: "new body")
    end
  end
end