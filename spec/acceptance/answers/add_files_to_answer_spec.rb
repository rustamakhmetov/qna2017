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
    within(:xpath, "//div[@id='attachments']/div[@class='nested-fields'][1]/div[@class='field']") do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end
    click_on 'add file'
    within(:xpath, "//div[@id='attachments']/div[@class='nested-fields'][2]/div[@class='field']") do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Ask answer'
    wait_for_ajax
    save_and_open_page

    expect(page).to have_link"spec_helper.rb", href: "/uploads/attachment/file/1/spec_helper.rb"
    expect(page).to have_link"rails_helper.rb", href: "/uploads/attachment/file/2/rails_helper.rb"
  end
end