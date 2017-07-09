require 'acceptance/acceptance_helper'

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

    expect(page).to have_content 'Answer was successfully created'
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

  context "multiple sessions" do
    given!(:question2) { create(:question) }
    scenario "answer on question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in user
        visit question_path(question)
        expect(page).to have_content question.title
        expect(page).to have_content question.body
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('guest2') do
        visit question_path(question2)
      end

      Capybara.using_session('user') do
        within("form.new_answer") do
          fill_in 'Body', with: 'text text'
          click_on 'Ask answer'
          wait_for_ajax
        end
        expect(page).to have_content 'Answer was successfully created'
        expect(page).to have_content 'text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'text text'
      end

      Capybara.using_session('guest2') do
        expect(page).to_not have_content 'text text'
      end
    end
  end

end