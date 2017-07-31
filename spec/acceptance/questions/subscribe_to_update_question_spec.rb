require 'acceptance/acceptance_helper'

feature 'Subscribe to update question', %q{
  In order to be able to receive notifications about the update of the question
  As an authenticated user
  I want to be able to subscribe an question
} do

  given(:user) { create(:user) }

  describe 'Authenticate user' do

    describe "Author of question" do
      given!(:question) { create(:question, user: user) }

      before do
        sign_in user
        visit question_path(question)
      end

      describe "unsubscribe" do
        scenario 'see unsubscribe link' do
          within '.question' do
            expect(Subscription.count).to eq 1
            expect(page).to have_link('Unsubscribe')
          end
        end

        scenario 'tried to unsubscribe on question', js: true do
          within '.question' do
            expect(page).to_not have_link('Subscribe')
            click_on 'Unsubscribe'
            wait_for_ajax
            expect(page).to_not have_link('Unsubscribe')
            expect(page).to have_link("Subscribe")
          end
        end
      end
    end

    describe "non-author of question" do
      given!(:question) { create(:question) }

      describe "subscribe" do
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
            wait_for_ajax
            expect(page).to_not have_link('Subscribe')
            expect(page).to have_link("Unsubscribe")
          end
        end

        scenario "rendered subscribe on question" do
          user.subscribe(question)
          visit question_path(question)
          expect(page).to_not have_link('Subscribe')
          expect(page).to have_link("Unsubscribe")
        end
      end

      describe "unsubscribe" do
        before do
          sign_in user
          user.subscribe(question)
          visit question_path(question)
        end

        scenario 'see unsubscribe link' do
          within '.question' do
            expect(page).to have_link('Unsubscribe')
          end
        end

        scenario 'tried to unsubscribe on question', js: true do
          within '.question' do
            expect(page).to_not have_link('Subscribe')
            click_on 'Unsubscribe'
            wait_for_ajax
            expect(page).to_not have_link('Unsubscribe')
            expect(page).to have_link("Subscribe")
          end
        end
      end
    end
  end

  describe "Non-authenticate user" do
    given!(:question) { create(:question, user: user) }

    before do
      visit question_path(question)
    end

    scenario 'does not see subscriber links' do
      within '.question' do
        expect(page).to_not have_link('Subscribe')
        expect(page).to_not have_link('Unsubscribe')
      end
    end
  end
end
