require 'rails_helper'

describe Answer do
  it { should belong_to :question}
  it { should validate_presence_of :question_id}
  it { should validate_presence_of :body}


  let(:test_answer) { create :answer }

  it 'test' do
    #p test_answer
    question = test_answer.question
    #p question
    #p question.answers
  end

end