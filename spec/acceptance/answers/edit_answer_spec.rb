require 'acceptance/acceptance_helper'

feature 'Edit answer', %q{
  In order to be able to fix mistake
  As an authenticated user
  I want to be able to edit an answer to the question
} do
  #given!(:question) { create(:question_with_answers, answers_count: 1) }
  given!(:question) { create(:question) }
  given!(:user) { question.user }



  describe 'Author' do
    given!(:answer) { create(:answer, question: question, user: user) }

    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'see edit link' do
      within '.answers' do
        expect(page).to have_link('Edit')
      end
    end

    scenario 'edit answer', js: true do
      within "#answer#{answer.id}" do
        expect(page).to_not have_selector("textarea")
        click_on 'Edit'
        expect(page).to_not have_link('Edit')
        expect(page).to have_selector("textarea")
        fill_in 'Body', with: 'new answer'
        click_on 'Save'
        expect(page).to_not have_selector("textarea")
        expect(page).to have_link('Edit')
        expect(page).to_not have_content(answer.body)
        expect(page).to have_content('new answer')
      end
    end
  end

  describe 'Non author' do
    given!(:answer) { create(:answer, question: question, user: create(:user) ) }

    before do
      sign_in user
      visit question_path(question)
    end

    scenario "don't see edit link" do
      within '.answers' do
        expect(page).to_not have_link('Edit')
      end
    end

    scenario "don't see update form" do
      within '.answers' do
        expect(page).to_not have_selector("textarea")
        expect(page).to_not have_link('Save')
      end
    end

  end

end