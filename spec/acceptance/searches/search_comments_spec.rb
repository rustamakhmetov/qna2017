require 'acceptance/acceptance_helper'

feature 'Search comments', %q{
  In order to be able find comments by request string
  As an user
  I want to be able send find's string
} do

  it_behaves_like "Searchable" do
    let(:condition) { "Comments" }
    let(:query) { "comment" }
    let!(:datas) { [
        {model: "Comments", attr: :body, objects: create_list(:comment, 10, commentable: create(:question),
                                                              commentable_type: "Question")},
    ]}
  end
end