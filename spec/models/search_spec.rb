require 'rails_helper'

RSpec.describe Search, type: :model do
  describe '.by_condition' do
    let!(:questions) { create_list(:question, 5)}

    it 'questions' do
      expect(Question).to receive(:search).with('question')
      Search.by_condition('Questions', 'question')
    end
  end
end