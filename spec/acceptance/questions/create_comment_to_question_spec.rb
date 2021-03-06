require 'acceptance/acceptance_helper'

feature "User can write an comment to a question", %q{
  In order to be able to clarify the problem
  As an user
  I want to be able to write an comment to the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe "Authenticated user" do
    scenario 'write comment to question', js: true do
      sign_in(user)

      visit question_path(question)
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      within("div#question#{question.id} div.comments") do
        fill_in 'Ваш комментарий', with: 'text text'
        click_on 'Add comment'
        wait_for_ajax
        within('textarea#comment_body') do
          expect(page).to_not have_content 'text text'
        end
      end
      expect(page).to have_content 'Your comment successfully added.'
      expect(page).to have_content 'text text'
    end

    scenario 'see comments for question', js: true do
      sign_in(user)

      3.times { question.comments << create(:comment, commentable: question, user: user) }
      visit question_path(question)

      within("div#question#{question.id} div.comments") do
        question.comments.each do |comment|
          expect(page).to have_content comment.body
        end
      end
    end

    scenario 'to be fill comment with invalid data', js: true do
      sign_in(user)

      visit question_path(question)
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      within("div#question#{question.id} div.comments") do
        fill_in 'Ваш комментарий', with: ''
        click_on 'Add comment'
        wait_for_ajax
      end

      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  describe "Non-authenticated user" do
    scenario 'see comments for question', js: true do
      3.times { question.comments << create(:comment, commentable: question, user: user) }
      visit question_path(question)

      within("div#question#{question.id} div.comments") do
        question.comments.each do |comment|
          expect(page).to have_content comment.body
        end
      end
    end

    scenario 'can not write comment to question', js: true do
      visit question_path(question)
      within("div#question#{question.id} div.comments") do
        expect(page).to_not have_selector "form#new_comment"
      end
    end
  end

  context "multiple sessions" do
    given!(:question2) { create(:question) }

    scenario "comment on question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in user
        visit question_path(question)
        expect(page).to have_content question.title
        expect(page).to have_content question.body
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('guest2') do
        visit question_path(question2)
      end

      Capybara.using_session('user') do
        within("div#question#{question.id} div.comments") do
          fill_in 'Ваш комментарий', with: 'text text'
          click_on 'Add comment'
          wait_for_ajax
        end
        expect(page).to have_content 'Your comment successfully added.'
        expect(page).to have_content 'text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'text text'
      end

      Capybara.using_session('guest2') do
        expect(page).to_not have_content 'text text'
      end
    end
  end
end