require 'acceptance/acceptance_helper'

feature 'Vote for question', %q{
  In order to be able vote for the question
  As an user
  I want to be able vote for the question
} do

  given(:user) { create(:user)}
  given(:question) { create(:question) }

  scenario 'Authenticate user vote up for question', js: true do
    sign_in(user)

    visit question_path(question)

    within(".vote") do
      expect(page).to have_css ".vote-up"
      find(:css, ".vote-up").click
      within(".vote-count") do
        expect(page).to have_content "1"
      end
    end
  end

  scenario "Author of question can't vote for question", js: true do
    sign_in(user)

    author_question = create(:question, user: user)
    visit question_path(author_question)

    within(".vote") do
      expect(page).to_not have_css ".vote-up"
      expect(page).to_not have_css ".vote-down"
    end
  end

  describe 'Authenticate user vote for question only one time' do

    scenario "vote up", js: true do
      sign_in(user)

      visit question_path(question)

      within("div#question#{question.id} > .vote") do
        expect(page).to have_css ".vote-up"
        within(".vote-count") do
          expect(page).to have_content "0"
        end
        find(:css, ".vote-up").click
        wait_for_ajax
        find(:css, ".vote-up").click
        wait_for_ajax

        within(".vote-count") do
          expect(page).to have_content "1"
        end
      end
    end

    scenario "vote down", js: true do
      sign_in(user)

      question.votes << create(:vote, user: user, votable: question, value: 1)
      question.votes << create(:vote, user: create(:user), votable: question, value: 1)

      visit question_path(question)

      within("div#question#{question.id} > .vote") do
        expect(page).to have_css ".vote-down"
        within(".vote-count") do
          expect(page).to have_content "2"
        end
        find(:css, ".vote-down").click
        wait_for_ajax
        find(:css, ".vote-down").click
        wait_for_ajax

        within(".vote-count") do
          expect(page).to have_content "0"
        end
      end
    end

    scenario "vote down after vote up", js: true do
      sign_in(user)

      visit question_path(question)

      within("div#question#{question.id} > .vote") do
        within(".vote-count") do
          expect(page).to have_content "0"
        end
        find(:css, ".vote-up").click
        wait_for_ajax
        find(:css, ".vote-down").click
        wait_for_ajax

        within(".vote-count") do
          expect(page).to have_content "-1"
        end
      end
    end

    scenario "vote up after vote down", js: true do
      sign_in(user)

      visit question_path(question)

      within("div#question#{question.id} > .vote") do
        within(".vote-count") do
          expect(page).to have_content "0"
        end
        find(:css, ".vote-down").click
        wait_for_ajax
        find(:css, ".vote-up").click
        wait_for_ajax

        within(".vote-count") do
          expect(page).to have_content "1"
        end
      end
    end


  end



  scenario 'Non-authenticate user ties vote for question', js: true do
    visit question_path(question)
    expect(page).to_not have_css(".vote_up")
    expect(page).to_not have_css(".vote_down")
  end
end