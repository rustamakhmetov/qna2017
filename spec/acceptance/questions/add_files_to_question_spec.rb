require 'acceptance/acceptance_helper'

feature 'Add files to question', %q{
  I order to be able illustrate my question
  As an authenticate user
  I want to be add files to question
} do

  given(:user) { create(:user)}

  scenario 'User add files to question' do
    sign_in(user)

    visit new_question_path

    fill_in 'Title', with: 'Title 1'
    fill_in 'Body', with: 'Body 1'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_link"spec_helper.rb", href: "/uploads/attachment/file/1/spec_helper.rb"
  end
end