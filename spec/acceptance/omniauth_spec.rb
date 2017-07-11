require 'acceptance/acceptance_helper'

feature 'Omniauth authorization', %q{
  In order to be able authorization from social network
  As an user
  I want to be able to sign in from social network
} do
  given!(:user) { create(:user) }

  scenario "Authorization from Facebook" do
    visit new_user_session_path
    expect(page).to have_link "Sign in with Facebook"

    omniauth_mock

    click_on "Sign in with Facebook"
    expect(page).to have_content "Successfully authenticated from Facebook account"
  end
end