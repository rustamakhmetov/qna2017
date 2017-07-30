require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:users) { create_list(:user, 1) }
  let!(:questions) { create_list(:question, 2, user: users.first)}
  let!(:questions_hash) do
    questions.each.map { |question| {title: question.title, url: question_url(question)} }
  end

  it 'should send daily digest to all users' do
    users.each { |user| expect(DailyMailer).to receive(:digest).with(user, questions_hash).and_call_original }
    DailyDigestJob.perform_now
  end
end

def question_url(obj)
  "http://localhost:3000/questions/#{obj.id}"
end
