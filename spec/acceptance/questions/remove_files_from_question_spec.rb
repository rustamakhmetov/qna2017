require 'acceptance/acceptance_helper'

feature 'Remove files from question', %q{
  I order to be able remove file from my question
  As an author of question
  I want to be remove files from question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question_with_attachments, count: 1) }

  scenario 'Author delete files from question', js: true do
    sign_in(question.user)

    visit question_path(question)

    within("#attachment1") do
      click_on 'remove file'
      wait_for_ajax
    end
    expect(page).to_not have_link "spec_helper.rb"
  end

  scenario 'Non-author can\'t delete files from question', js: true do
    expect(question.user).to_not eq user
    sign_in(user)

    visit question_path(question)

    within("#attachments1") do
      expect(page).to_not have_link"remove file"
    end
  end
end