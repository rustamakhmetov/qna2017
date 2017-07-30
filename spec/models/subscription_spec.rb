require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to :user}
  it { should belong_to :question}

  describe 'Number of questions that can be subscribed to the user' do
    let!(:user) { create(:user) }
    let!(:questions) { create_list(:question, 5)}

    it 'is unlimited' do
      expect { questions.each {|question| user.subscribe(question)} }.to change(Subscription, :count).by(5)
    end
  end
end
