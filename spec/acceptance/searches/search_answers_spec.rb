require 'acceptance/acceptance_helper'

feature 'Search answers', %q{
  In order to be able find answers by request string
  As an user
  I want to be able send find's string
} do

  it_behaves_like "Searchable" do
    let!(:objects) { create_list(:answer, 10) }
    let(:model) { "Answers" }
    let(:attr) { :body }
    let(:query) { "body" }
  end
end