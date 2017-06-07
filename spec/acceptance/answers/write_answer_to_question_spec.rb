require "rails_helper"

feature "User can write an answer to a question", %q{
  In order to be able to help solve the problem
  As an user
  I want to be able to write an answer to the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user answer to question', js: true do
    sign_in(user)

    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body

    fill_in 'Body', with: 'text text'
    click_on 'Ask answer'
    wait_for_ajax

    expect(page).to have_content 'Ответ успешно добавлен'
    expect(page).to have_content 'text text'
  end

  scenario 'Authenticated user to be fill answer invalid data', js: true do
    sign_in(user)

    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body

    fill_in 'Body', with: ''
    click_on 'Ask answer'
    wait_for_ajax

    expect(page).to have_content 'Body can\'t be blank'
  end

  scenario 'Non-authenticated user can not answer to question', js: true do
    visit question_path(question)
    click_on 'Ask answer'
    wait_for_ajax

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end