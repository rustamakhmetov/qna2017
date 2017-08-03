require 'acceptance/acceptance_helper'

feature 'Search questions', %q{
  In order to be able find questions by request string
  As an user
  I want to be able send find's string
} do

  it_behaves_like "Searchable" do
    let!(:objects) { create_list(:question, 10) }
    let(:model) { "Questions" }
    let(:attr) { :title }
    let(:query) { "question" }
  end
end