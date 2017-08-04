require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #search' do
    let!(:questions) { create_list(:question, 10) }
    let(:query) { "question" }
    subject { get :search, params: { query: query, condition: "Questions", format: :js } }

    it 'call search' do
      expect(Search).to receive(:by_condition).with("Questions", query)
      subject
    end
  end
end