require 'rails_helper'

describe Question do
  subject { build(:question) }
  it { should belong_to :user}
  it { should have_many(:answers).dependent(:destroy)}
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should validate_presence_of :title}
  it { should validate_presence_of :body}
  it { should accept_nested_attributes_for :attachments }

  describe "reputation" do
    let(:user) { create(:user) }
    subject { build(:question, user: user)}

    it "should calculate reputation after creating" do
      expect(Reputation).to receive(:calculate)
      subject.save!
    end

    it "should not calculate reputation after update" do
      subject.save!
      expect(Reputation).to_not receive(:calculate).with(subject)
      subject.update(title: "12345")
    end

    it "should save user reputation" do
      allow(Reputation).to receive(:calculate).and_return(5)
      expect { subject.save! }.to change(user, :reputation).by(5)
    end

    it 'test time' do
      now = Time.now.utc
      allow(Time).to receive(:now) { now }
      subject.save!
      expect(subject.created_at).to eq now
    end

    it 'test double' do
      allow(Question).to receive(:find) { double(Question, title: '123') }
      expect(Question.find(155).title).to eq '123'
    end
  end

  it_behaves_like "votable"
end