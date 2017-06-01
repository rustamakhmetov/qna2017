require "rails_helper"

feature "User can write an answer to a question", %q{
  In order to be able to help solve the problem
  As an user
  I want to be able to write an answer to the question
} do

  given(:user) { create(:user) }

  let(:question) { create(:question) }

  scenario 'Authenticated user answer to question' do
    sign_in(user)

    visit question_path(question)
    #save_and_open_page
    expect(page).to have_content question.title
    expect(page).to have_content question.body

    fill_in 'Body', with: 'text text'
    click_on 'Ask answer'

    expect(page).to have_content 'Ответ успешно добавлен'
    expect(page).to have_content 'text text'
  end

  scenario 'Non-authenticated user can not answer to question' do
    visit question_path(question)
    click_on 'Ask answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end