require 'rails_helper'

describe Answer do
  it { should belong_to :user}
  it { should belong_to :question}
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should accept_nested_attributes_for :attachments }
  it { should validate_presence_of :body}
  it { should have_db_column(:accept) }
  it { should have_many(:votes).dependent(:destroy) }
  it_behaves_like "votable"

  describe 'accept answer' do
    let(:question) { create(:question) }
    let!(:answer1) { create(:answer, question: question, id: 3) }
    let!(:answer2) { create(:answer, question: question, accept: true, id: 2) }
    let!(:answer3) { create(:answer, question: question, id: 1) }
    let!(:answer4) { create(:answer, question: question, accept: true) }

    context 'with valid attributes'  do
      context 'accept answer1' do
        it { expect { answer4.accept! }.to_not change { answer4.reload.accept }.from(true) }
        it { expect { answer4.accept! }.to change { answer2.reload.accept }.from(true).to(false) }
        it { expect { answer1.accept! }.to change { answer1.reload.accept }.from(false).to(true) }
        it { expect { answer1.accept! }.to change { answer2.reload.accept }.from(true).to(false) }
        it { expect { answer1.accept! }.to_not change { answer3.reload.accept }.from(false) }
      end
    end

    context 'with invalid attributes'  do
      context 'answer not belongs to question' do
        subject { lambda { create(:answer, question: create(:question)).accept! } }

        it { should_not change { answer1.reload.accept }.from(false) }
        it { should_not change { answer2.reload.accept }.from(true) }
      end
    end
  end

  describe "reputation" do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    subject { build(:answer, question: question, user: user)}

    it "should calculate reputation after creating" do
      expect(Reputation).to receive(:calculate).with(subject)
      subject.save!
    end

    it "should not calculate reputation after update" do
      subject.save!
      expect(Reputation).to_not receive(:calculate).with(subject)
      subject.update(body: "123")
    end
  end
end