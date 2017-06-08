require 'acceptance/acceptance_helper'

feature 'Removal of the author answers', %q{
  In order to be able to remove my answers
  As an authenticated user
  I want to be able to remove my answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question_with_answers, user: user) }

  scenario 'Authenticated author delete your answer' do
    sign_in(user)

    qpath = question_path(question)
    visit qpath
    answer_anchor = "Delete answer #{question.answers.first.id}"
    click_on answer_anchor
    expect(page).to have_content 'Ответ успешно удален.'
    expect(current_path).to eq qpath
    expect(page).to_not have_link(answer_anchor)
  end

  scenario 'Authenticated author can not delete other answer' do
    sign_in(user)

    answer = create(:answer, user: create(:user), question: question)
    visit question_path(question)
    expect(page).to_not have_link "Delete answer #{answer.id}"
  end

  scenario 'Non-authenticated user can not delete answers' do
    visit question_path(question)
    question.answers.each do |answer|
      expect(page).to_not have_link "Delete answer #{answer.id}"
    end
  end

end