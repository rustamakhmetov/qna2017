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

  fdescribe "reputation" do
    let(:user) { create(:user) }
    subject { build(:question, user: user)}

    it_behaves_like 'calculates reputation'
  end

  it_behaves_like "votable"
end