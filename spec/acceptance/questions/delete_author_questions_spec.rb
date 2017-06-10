require 'acceptance/acceptance_helper'

feature 'Removal of the author questions', %q{
  In order to be able to remove my questions
  As an authenticated user
  I want to be able to remove my questions
} do

  given(:user) { create(:user) }
  given(:question) { create(:question_with_answers, user: user) }

  scenario 'Authenticated author delete your question' do
    sign_in(user)

    question
    visit questions_path
    expect(page).to have_content question.title

    visit question_path(question)
    click_on 'Delete question'
    expect(page).to have_content 'Вопрос успешно удален.'
    expect(current_path).to eq questions_path
    expect(page).to_not have_content question.title
  end

  scenario 'Authenticated author can not delete other question' do
    sign_in(user)

    qpath = question_path(create(:question, user: create(:user)))
    visit qpath
    expect(page).to_not have_link 'Delete question'
  end

  scenario 'Non-authenticated user can not delete question' do
     visit question_path(question)
     expect(page).to_not have_link "Delete question"
  end

end