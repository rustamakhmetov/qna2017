require 'acceptance/acceptance_helper'

feature 'Edit question', %q{
  In order to be able to update post
  As an authenticated user
  I want to be able to edit an question
} do

  given(:user) { create(:user) }

  describe 'Author' do
    given!(:question) { create(:question, user: user) }

    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'see edit link' do
      within '.question' do
        expect(page).to have_link('Edit')
      end
    end

    scenario 'edit question', js: true do
      within '.question' do
        expect(page).to_not have_selector("form.edit_question")
        click_on 'Edit'
        expect(page).to_not have_link('Edit')
        expect(page).to have_selector("textarea")
        fill_in 'Body', with: 'new question'
        click_on 'Save'
        expect(page).to_not have_selector("form.edit_question")
        expect(page).to have_link('Edit')
        expect(page).to_not have_content(question.body)
        expect(page).to have_content('new question')
      end
    end
  end

  describe 'Non author' do
    given!(:question) { create(:question, user: create(:user) ) }

    before do
      sign_in user
      visit question_path(question)
    end

    scenario "don't see edit link" do
      within '.question' do
        expect(page).to_not have_link('Edit')
      end
    end

    scenario "don't see update form" do
      within '.question' do
        expect(page).to_not have_selector("form.edit_question")
        expect(page).to_not have_link('Save')
      end
    end

  end

end