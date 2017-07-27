require 'acceptance/acceptance_helper'

feature 'Subscribe to update question', %q{
  In order to be able to receive notifications about the update of the question
  As an authenticated user
  I want to be able to subscribe an question
} do

  given(:user) { create(:user) }

  describe 'Authenticate user' do
    given!(:question) { create(:question, user: user) }

    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'see subscribe link' do
      within '.question' do
        expect(page).to have_link('Subscribe')
      end
    end

    scenario 'tried to subscribe on question', js: true do
      within '.question' do
        expect(page).to_not have_link('Unsubscribe')
        click_on 'Subscribe'
        expect(page).to_not have_link('Subscribe')
        expect(page).to have_link("Unsubscribe")
      end
    end

    scenario "rendered subscribe on question" do
      question.subscriptions.create(user: user)
      visit question_path(question)
      expect(page).to_not have_link('Subscribe')
      expect(page).to have_link("Unsubscribe")
    end
  end
end
