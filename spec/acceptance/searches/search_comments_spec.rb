require 'acceptance/acceptance_helper'

feature 'Search comments', %q{
  In order to be able find comments by request string
  As an user
  I want to be able send find's string
} do

  given(:user) { create(:user)}
  let!(:question) { create(:question) }
  let!(:comments) { create_list(:comment, 10, commentable: question, commentable_type: "Question") }

  describe "Non-authenticate user" do
    scenario 'find comments', js: true do
      ThinkingSphinx::Test.run do
        index
        visit questions_path
        within '.search' do
          fill_in 'query', with: 'comment'
          select 'Comments', from: :condition
          click_on 'Search'
          wait_for_ajax
        end
        within '.search-results > .comments' do
          comments.each do |comment|
            expect(page).to have_content comment.body
          end
        end
      end
    end
  end
end