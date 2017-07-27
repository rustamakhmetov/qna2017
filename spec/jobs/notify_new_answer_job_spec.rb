require 'rails_helper'

RSpec.describe NotifyNewAnswerJob, type: :job do
  let!(:answer) { create(:answer) }

  it "should send notify of a new answer to author of question" do
    expect(DailyMailer).to receive(:new_answer).with(answer).and_call_original
    NotifyNewAnswerJob.perform_now(answer)
  end
end
