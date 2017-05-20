require 'rails_helper'

RSpec.describe Question, type: :model do
  it 'validates presence of title' do
    expect(Question.new(body: 'fssdsdfsf')).to_not be_valid
  end
  
  it 'validates presence of body' do
    expect(Question.new(title: 'ertreetrt')).to_not be_valid
  end
end