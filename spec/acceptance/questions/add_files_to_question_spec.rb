require 'acceptance/acceptance_helper'

feature 'Add files to question', %q{
  I order to be able illustrate my question
  As an authenticate user
  I want to be add files to question
} do

  given(:user) { create(:user)}

  scenario 'User add files to question', js: true do
    sign_in(user)

    visit new_question_path

    fill_in 'Title', with: 'Title 1'
    fill_in 'Body', with: 'Body 1'

    within(:xpath, "//div[@id='attachments']/div[@class='nested-fields'][1]/div[@class='field']") do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end
    click_on 'add file'
    within(:xpath, "//div[@id='attachments']/div[@class='nested-fields'][2]/div[@class='field']") do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Create'

    expect(page).to have_link"spec_helper.rb", href: "/uploads/attachment/file/1/spec_helper.rb"
    expect(page).to have_link"rails_helper.rb", href: "/uploads/attachment/file/2/rails_helper.rb"
  end
end