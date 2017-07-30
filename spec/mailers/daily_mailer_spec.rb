require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe ".digest" do
    let(:user) { create(:user) }
    let(:questions_hash) { 2.times.map {|i| {title: "Title #{i}", url: "/questions/#{i}"} } }
    let(:mail1) { DailyMailer.digest(user, questions_hash) }

    it "assigns question_hash to @questions" do
      mail :digest, user, questions_hash
      expect(assigns(:questions).map { |question| question.symbolize_keys }).to eq questions_hash
    end

    it "renders the headers" do
      expect(mail1.subject).to eq("New questions for last 24h")
      expect(mail1.to).to eq [user.email]
      expect(mail1.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      questions_hash.each do |question|
        expect(mail1.body.encoded).to match("#{question[:title]}")
        expect(mail1.body.encoded).to match("#{question[:url]}")
      end
    end
  end

  describe ".notify_new_answer" do
    let!(:answer) { create(:answer) }
    let(:question) { answer.question }
    let(:user) { answer.question.user }
    let(:mail1) { DailyMailer.notify_new_answer(user, answer) }

    it "assigns answer to @answer" do
      mail :notify_new_answer, user, answer
      expect(assigns(:answer)).to eq answer
      expect(assigns(:question)).to eq question
    end

    it "renders the headers" do
      expect(mail1.subject).to eq("New answer for question '#{question.title}'")
      expect(mail1.to).to eq [user.email]
      expect(mail1.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail1.body.encoded).to match("#{answer.body}")
      expect(mail1.body.encoded).to match("#{question_url(question)}")
    end
  end

  describe ".notify_update_question" do
    let!(:question) { create(:question) }
    let(:user) { question.user }
    let(:mail1) { DailyMailer.notify_update_question(user, question) }

    it "assigns question to @question" do
      mail :notify_update_question, user, question
      expect(assigns(:question)).to eq question
    end

    it "renders the headers" do
      expect(mail1.subject).to eq("The content of the question '#{question.title}' has been updated")
      expect(mail1.to).to eq [user.email]
      expect(mail1.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail1.body.encoded).to match("#{question.body}")
      expect(mail1.body.encoded).to match("#{question_url(question)}")
    end
  end
end
