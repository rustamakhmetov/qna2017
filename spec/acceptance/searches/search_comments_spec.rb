require 'acceptance/acceptance_helper'

feature 'Search comments', %q{
  In order to be able find comments by request string
  As an user
  I want to be able send find's string
} do

  it_behaves_like "Searchable" do
    let(:question) { create(:question) }
    let!(:objects) { create_list(:comment, 10, commentable: question, commentable_type: "Question") }
    let(:model) { "Comments" }
    let(:attr) { :body }
    let(:query) { "comment" }
  end
end