require 'rails_helper'

RSpec.describe NotifyNewAnswerJob, type: :job do
  let!(:answer) { create(:answer) }
  let(:question) { answer.question }

  describe "should send notify of a new answer" do
    it "to the author of question" do
      expect(DailyMailer).to receive(:notify_new_answer).with(answer.question.user, answer).and_call_original
      NotifySubscribersJob.perform_now(answer)
    end

    it "to the subscriber user" do
      subscriptions = create_list(:subscription, 2, question: question)
      Subscription.all.each do |subscription|
        expect(DailyMailer).to receive(:notify_new_answer).with(subscription.user, answer).and_call_original
      end
      NotifySubscribersJob.perform_now(answer)
    end
  end
end
