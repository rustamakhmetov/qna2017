require 'rails_helper'

feature 'User sign up', %q{
  In order to be able to ask question
  As an user
  I want to be able to sign up
} do

  given(:user) { create(:user) }

  scenario 'Registered user try to sign up' do
    sign_in(user)
    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path

    visit new_user_registration_path
    expect(page).to have_content 'You are already signed in.'
  end

  scenario 'Non-registered user try to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'new_user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'You have signed up successfully.'
  end

  scenario 'Non-registered user try to sign up with invalid data' do
    visit new_user_registration_path
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'
    expect(page).to have_content "Email can't be blank"
  end
end