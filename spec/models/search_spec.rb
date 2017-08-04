require 'rails_helper'

RSpec.describe Search, type: :model do
  describe '.by_condition' do
    it_behaves_like "Searched" do
      let(:classes) { [Question] }
      let(:condition) { "Questions"}
    end

    it_behaves_like "Searched" do
      let(:classes) { [Answer] }
      let(:condition) { "Answers"}
    end

    it_behaves_like "Searched" do
      let(:classes) { [Comment] }
      let(:condition) { "Comments"}
    end

    it_behaves_like "Searched" do
      let(:classes) { [User] }
      let(:condition) { "Users"}
    end

    it_behaves_like "Searched" do
      let(:classes) { [Question, Answer, Comment, User] }
      let(:condition) { "Any"}
    end

    it_behaves_like "Searched" do
      let(:classes) { [Question, Answer, Comment, User] }
      let(:condition) { "Unknow"}
    end
  end
end