FactoryGirl.define do
  sequence :title do |n|
    "Question #{n}"
  end

  sequence :body do |n|
    "Body #{n}"
  end

  factory :question do
    title
    body
    factory :question_with_answers do
      transient do
        answers_count 5
      end
      after :create do |question, evaluator|
        FactoryGirl.create_list(:answer, evaluator.answers_count, :question => question)
      end
    end

  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end