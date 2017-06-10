require 'acceptance/acceptance_helper'

feature 'Right answer', %q{
  In order to be able to solve my problem
  As an user
  I want to be able to see first the right answer
} do
  given(:question) { create(:question) }
  given(:user) { question.user  }
  given!(:answer1) { create(:answer, question: question, user: user, id: 1) }
  given!(:answer2) { create(:answer, question: question, user: user, id: 2) }
  given!(:answer3) { create(:answer, question: question, user: user, id: 3, accept: true) }

  before do
    visit question_path(question)
  end

  scenario "first in list answers" do
    first_answer = first(:xpath, "//div[@class='answers']/div[1]")
    expect(first_answer[:id]).to eq "answer3"
    within first_answer do
      expect(page).to_not have_link('Accept')
      expect(page).to have_selector("span.accept")
    end
  end
end


