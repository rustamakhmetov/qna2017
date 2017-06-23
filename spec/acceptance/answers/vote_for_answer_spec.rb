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

  scenario 'Non-authenticate user ties vote for answer', js: true do
    visit question_path(answer.question)
    within("div#answer#{answer.id}") do
      expect(page).to_not have_css(".vote_up")
      expect(page).to_not have_css(".vote_down")
    end
  end
end