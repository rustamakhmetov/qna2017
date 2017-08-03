require 'acceptance/acceptance_helper'

feature 'Search users', %q{
  In order to be able find users by request string
  As an user
  I want to be able send find's string
} do

  it_behaves_like "Searchable" do
    let(:condition) { "Users" }
    let(:query) { "text*" }
    let!(:datas) { [
        {model: "Users", attr: :email, objects: 10.times.map {|i| create(:user, email: "user#{i}@text.com")}}
    ]}
  end
end