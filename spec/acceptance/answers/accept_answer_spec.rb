require 'acceptance/acceptance_helper'

feature 'Accept answer', %q{
  In order to be able to accept right answer solved problem
  As an author of question
  I want to be able to accept an answer to the question
} do

  describe 'Author of question' do
    given(:question) { create(:question) }
    given(:user) { question.user  }
    given!(:other_user) { create(:user) }
    given!(:answer) { create(:answer, question: question, user: other_user, body: "Answer [accept]") }
    given!(:answer2) { create(:answer, question: question, user: other_user) }
    given!(:answer3) { create(:answer, question: question, user: other_user, accept: true) }

    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'see accept link' do
      within '.answers' do
        expect(page).to have_link('Accept')
      end
    end

    scenario 'accept answer', js: true do
      within "div#answer#{answer.id}" do
        click_on 'Accept'
        wait_for_ajax
        expect(page).to_not have_link('Accept')
        expect(page).to have_selector("span.accept")
      end
      [answer2, answer3].each do |a|
        within "div#answer#{a.id}" do
          expect(page).to have_link('Accept')
          expect(page).to_not have_selector("span.accept")
        end
      end
    end

    scenario 'accept other answer', js: true do
      # accept answer
      within "div#answer#{answer.id}" do
        click_on 'Accept'
        wait_for_ajax
        expect(page).to_not have_link('Accept')
        expect(page).to have_selector("span.accept")
      end
      [answer2, answer3].each do |a|
        within "div#answer#{a.id}" do
          expect(page).to have_link('Accept')
          expect(page).to_not have_selector("span.accept")
        end
      end
      # accept answer3
      within "div#answer#{answer3.id}" do
        click_on 'Accept'
        wait_for_ajax
        expect(page).to_not have_link('Accept')
        expect(page).to have_selector("span.accept")
      end
      [answer2, answer].each do |a|
        within "div#answer#{a.id}" do
          expect(page).to have_link('Accept')
          expect(page).to_not have_selector("span.accept")
        end
      end

    end

  end

  describe 'Non author of question' do
    given(:user) { create(:user) }
    given(:question) { create(:question, user: create(:user))}
    given!(:answer) { create(:answer, question: question, user: create(:user) ) }

    before do
      sign_in user
      visit question_path(question)
    end

    scenario "don't see accept link" do
      within '.answers' do
        expect(page).to_not have_link('Accept')
      end
    end
  end

  describe 'Non-authenticated user' do
    given(:question) { create(:question) }
    given(:user) { question.user  }
    given!(:answer) { create(:answer, question: question, user: user) }

    scenario 'can not see accept link on answer of question' do
      visit question_path(question)
      within '.answers' do
        expect(page).to_not have_link('Accept')
      end
    end
  end
end