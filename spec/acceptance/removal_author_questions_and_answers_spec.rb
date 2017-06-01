require 'rails_helper'

feature 'Removal of the author questions and answers', %q{
  In order to be able to remove my questions and answers
  As an authenticated user
  I want to be able to remove my questions and answers
} do

  given(:user) do
    create(:user)
  end

  given(:question) do
    create(:question_with_answers, user: user)
  end

  scenario 'Authenticated author delete your question' do
    sign_in(user)

    question
    visit questions_path
    expect(page).to have_content question.title

    visit question_path(question)
    click_on 'Delete question'
    expect(page).to have_content 'Вопрос успешно удален.'
    expect(current_path).to eq questions_path
    expect(page).to_not have_content question.title
  end

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

  scenario 'Authenticated author can not delete other question' do
    sign_in(user)

    qpath = question_path(create(:question, user: create(:user)))
    visit qpath
    expect(page).to_not have_link 'Delete question'
  end

  scenario 'Authenticated author can not delete other answer' do
    sign_in(user)

    answer = create(:answer, user: create(:user), question: question)
    visit question_path(question)
    expect(page).to_not have_link "Delete answer #{answer.id}"
  end
end