require 'acceptance/acceptance_helper'

feature 'Vote for answer', %q{
  In order to be able vote for the answer
  As an user
  I want to be able vote for the answer
} do

  given(:user) { create(:user)}
  given(:answer) { create(:answer) }

  scenario 'Authenticate user vote up for answer', js: true do
    sign_in(user)

    visit question_path(answer.question)

    within("div#answer#{answer.id} > .vote") do
      expect(page).to have_css ".vote-up"
      find(:css, ".vote-up").click
      within(".vote-count") do
        expect(page).to have_content "1"
      end
    end
  end

  scenario "Author of answer can't vote for answer", js: true do
    sign_in(user)

    author_answer = create(:answer, user: user)
    visit question_path(author_answer.question)

    within("div#answer#{author_answer.id} > .vote") do
      expect(page).to_not have_css ".vote-up"
      expect(page).to_not have_css ".vote-down"
    end
  end

  describe 'Authenticate user vote for answer only one time' do

    scenario "vote up", js: true do
      sign_in(user)

      visit question_path(answer.question)

      within("div#answer#{answer.id} > .vote") do
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

      answer.votes << create(:vote, user: user, votable: answer, value: 1)
      answer.votes << create(:vote, user: create(:user), votable: answer, value: 1)

      visit question_path(answer.question)

      within("div#answer#{answer.id} > .vote") do
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

      visit question_path(answer.question)

      within("div#answer#{answer.id} > .vote") do
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

      visit question_path(answer.question)

      within("div#answer#{answer.id} > .vote") do
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

  scenario 'Non-authenticate user ties vote for answer', js: true do
    visit question_path(answer.question)
    within("div#answer#{answer.id}") do
      expect(page).to_not have_css(".vote_up")
      expect(page).to_not have_css(".vote_down")
    end
  end
end