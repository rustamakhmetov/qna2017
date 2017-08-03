require 'acceptance/acceptance_helper'

feature 'Search users', %q{
  In order to be able find users by request string
  As an user
  I want to be able send find's string
} do

  it_behaves_like "Searchable" do
    let!(:objects) { create_list(:user, 10) }
    let(:model) { "Users" }
    let(:attr) { :email }
    let(:query) { "user*" }
  end
end