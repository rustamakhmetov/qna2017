require 'acceptance/acceptance_helper'

feature "User can view a list of questions", %q{
  In order to be able to solve my problem
  As an user
  I want to be able to view a list of questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user can view a list of questions' do
    sign_in(user)

    questions = create_list(:question, 5)
    visit questions_path
    questions.each do |q|
      expect(page).to have_content(q.title)
    end
  end

  scenario 'Non-authenticated user can view a list of questions' do
    questions = create_list(:question, 5)
    visit questions_path
    questions.each do |q|
      expect(page).to have_content(q.title)
    end
  end

end