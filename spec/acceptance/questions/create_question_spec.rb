require 'rails_helper'

feature 'Create question', %q{
  In order to be able get answer
  As an user
  I want to be able ask question
} do

  given(:user) { create(:user)}

  scenario 'Authenticate user ask question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'Title 1'
    fill_in 'Body', with: 'Body 1'
    click_on 'Create'

    expect(page).to have_content 'Title 1'
    expect(page).to have_content 'Body 1'
    expect(page).to have_content 'Your question successfully created.'
  end

  scenario 'Authenticate user ask invalid question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: ''
    fill_in 'Body', with: 'Body 1'
    click_on 'Create'

    expect(page).to have_content 'Title can\'t be blank'
  end

  scenario 'Non-authenticate user ties ask question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end