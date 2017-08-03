require 'acceptance/acceptance_helper'

feature 'Search questions', %q{
  In order to be able find questions by request string
  As an user
  I want to be able send find's string
} do

  given(:user) { create(:user)}
  let!(:questions) { create_list(:question, 10) }

  describe "Non-authenticate user" do
    scenario 'find questions', js: true do
      ThinkingSphinx::Test.run do
        index
        visit questions_path
        within '.search' do
          fill_in 'query', with: 'question'
          select 'Questions', from: :condition
          click_on 'Search'
          wait_for_ajax
        end
        within '.search-results > .questions' do
          questions.each do |question|
            expect(page).to have_content question.title
          end
        end
      end
    end
  end
end