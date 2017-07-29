require 'rails_helper'

RSpec.describe NotifySubscribersJob, type: :job do
  let!(:question) { create(:question) }
  let(:subscriptions) { create_list(:subscription, 2, question: question) }
  let(:answer) { create(:answer, question: question) }

  describe "should send notify to the subscribers" do
    it 'when a update question' do
      Subscription.all.each { |subscription| expect(DailyMailer).to receive(:notify_update_question).with(subscription.user, question).and_call_original }
      NotifySubscribersJob.perform_now(question)
    end

    it 'when a new answer' do
      Subscription.all.each { |subscription| expect(DailyMailer).to receive(:notify_new_answer).with(subscription.user, answer).and_call_original }
      NotifySubscribersJob.perform_now(answer)
    end
  end
end
