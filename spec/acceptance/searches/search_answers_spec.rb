require 'acceptance/acceptance_helper'

feature 'Search answers', %q{
  In order to be able find answers by request string
  As an user
  I want to be able send find's string
} do

  given(:user) { create(:user)}
  let!(:answers) { create_list(:answer, 10) }

  describe "Non-authenticate user" do
    scenario 'find answers', js: true do
      ThinkingSphinx::Test.run do
        expect(Answer.count).to eq answers.count
        index
        visit questions_path
        within '.search' do
          fill_in 'query', with: 'body'
          select 'Answers', from: :condition
          click_on 'Search'
          wait_for_ajax
        end
        within '.search-results > .answers' do
          answers.each do |answer|
            expect(page).to have_content answer.body
          end
        end
      end
    end
  end
end