require 'acceptance/acceptance_helper'

feature 'Search users', %q{
  In order to be able find users by request string
  As an user
  I want to be able send find's string
} do

  given(:user) { create(:user)}
  let!(:users) { create_list(:user, 10) }

  describe "Non-authenticate user" do
    scenario 'find users', js: true do
      ThinkingSphinx::Test.run do
        index
        visit questions_path
        within '.search' do
          fill_in 'query', with: 'user*'
          select 'Users', from: :condition
          click_on 'Search'
          wait_for_ajax
        end
        within '.search-results > .users' do
          users.each do |user|
            expect(page).to have_content user.email
          end
        end
      end
    end
  end
end