require 'acceptance/acceptance_helper'

feature 'Search', %q{
  In order to be able find results by request string
  As an user
  I want to be able send find's string
} do

  describe "with Questions" do
    it_behaves_like "Searchable" do
      let(:condition) { "Questions" }
      let(:query) { "question" }
      let!(:data) { [
          {model: "Questions", attr: :title, objects: create_list(:question, 10)},
      ]}
    end
  end

  describe "with Answers" do
    it_behaves_like "Searchable" do
      let(:condition) { "Answers" }
      let(:query) { "body" }
      let!(:data) { [
          {model: "Answers", attr: :body, objects: create_list(:answer, 10)},
      ]}
    end
  end

  describe "with Comments" do
    it_behaves_like "Searchable" do
      let(:condition) { "Comments" }
      let(:query) { "comment" }
      let!(:data) { [
          {model: "Comments", attr: :body, objects: create_list(:comment, 10, commentable: create(:question),
                                                                commentable_type: "Question")},
      ]}
    end
  end

  describe "with Users" do
    it_behaves_like "Searchable" do
      let(:condition) { "Users" }
      let(:query) { "text*" }
      let!(:data) { [
          {model: "Users", attr: :email, objects: 10.times.map {|i| create(:user, email: "user#{i}@text.com")}}
      ]}
    end
  end

  describe "with Any" do
    it_behaves_like "Searchable" do
      let!(:text) { "search-text" }
      let(:condition) { "Any" }
      let(:query) { "text*" }
      let!(:data) { [
          {model: "Questions", attr: :title, objects: create_list(:question, 3, body: text)},
          {model: "Answers", attr: :body, objects: create_list(:answer, 3, body: text)},
          {model: "Comments", attr: :body, objects: create_list(:comment, 3, commentable: create(:question),
                                                                commentable_type: "Question", body: text)},
          {model: "Users", attr: :email, objects: 3.times.map {|i| create(:user, email: "user#{i}@#{text}.com")}}
      ]}
    end
  end
end