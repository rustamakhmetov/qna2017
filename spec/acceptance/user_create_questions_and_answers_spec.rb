require 'rails_helper'

feature 'Create questions and answers', %q{
  In order to be able solved problem or to get answer from community
  As an authenticated user
  I want to be able to ask questions and create answers
} do

  given(:user) do
    create(:user)
  end

  given(:question) do
    create(:question)
  end

  scenario 'Authenticated user create question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Body question'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'Body question'
  end

  scenario 'Authenticated user create answer' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: 'Answer body 1'
    click_on 'Ask answer'

    expect(page).to have_content 'Ответ успешно добавлен'
    expect(page).to have_content 'Answer body 1'
  end

  scenario 'Non-authenticated user create question and answers' do
    visit questions_path
    click_on 'Ask question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'

    visit question_path(question)
    click_on 'Ask answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end