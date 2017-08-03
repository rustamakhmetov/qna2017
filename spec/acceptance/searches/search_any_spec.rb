require 'acceptance/acceptance_helper'

feature 'Search users', %q{
  In order to be able find users by request string
  As an user
  I want to be able send find's string
} do

  it_behaves_like "Searchable" do
    let!(:text) { "search-text" }
    let(:condition) { "Any" }
    let(:query) { "text*" }
    let!(:datas) { [
        {model: "Questions", attr: :title, objects: create_list(:question, 10, body: text)},
        {model: "Answers", attr: :body, objects: create_list(:answer, 10, body: text)},
        {model: "Comments", attr: :body, objects: create_list(:comment, 10, commentable: create(:question),
                                                              commentable_type: "Question", body: text)},
        {model: "Users", attr: :email, objects: 10.times.map {|i| create(:user, email: "user#{i}@#{text}.com")}}
    ]}
  end
end