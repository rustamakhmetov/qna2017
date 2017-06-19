require 'acceptance/acceptance_helper'

feature 'Remove files from answer', %q{
  I order to be able remove file from my answer
  As an author of answer
  I want to be remove files from answer
} do

  given!(:user) { create(:user) }
  given!(:answer) { create(:answer_with_attachments, count: 1) }

  scenario 'Author delete files from answer', js: true do
    sign_in(answer.user)

    visit question_path(answer.question)

    within("div#answer_attachments > div#attachment1") do
      click_on 'remove file'
      wait_for_ajax
    end
    expect(page).to_not have_link "spec_helper.rb"
  end

  scenario 'Non-author can\'t delete files from answer', js: true do
    expect(answer.user).to_not eq user
    sign_in(user)

    visit question_path(answer.question)

    within("#answer_attachments") do
      expect(page).to_not have_link"remove file"
    end
  end
end