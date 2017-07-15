require 'acceptance/acceptance_helper'

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
    expect(page).to_not have_content 'Ask question'
    expect(page).to have_content "Log in"
  end

  context "multiple sessions" do
    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in user
        visit questions_path
      end

      Capybara.using_session('user2') do
        sign_in create(:user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'

        fill_in 'Title', with: 'Title 1'
        fill_in 'Body', with: 'Body 1'
        click_on 'Create'

        expect(page).to have_content 'Title 1'
        expect(page).to have_content 'Body 1'
        expect(page).to have_content 'Your question successfully created.'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Title 1'
      end

      Capybara.using_session('user2') do
        expect(page).to have_content 'Title 1'
      end
    end
  end
end