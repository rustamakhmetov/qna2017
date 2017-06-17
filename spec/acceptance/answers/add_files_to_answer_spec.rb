require 'acceptance/acceptance_helper'

feature 'Add files to answer', %q{
  I order to be able illustrate my answer
  As an authenticate user
  I want to be add files to answer
} do

  given(:user) { create(:user)}
  given(:question) { create(:question) }

  scenario 'User add files to answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Body', with: 'Body 1'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Ask answer'

    expect(page).to have_link"spec_helper.rb", href: "/uploads/attachment/file/1/spec_helper.rb"
  end
end