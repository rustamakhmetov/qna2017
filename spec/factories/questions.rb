FactoryGirl.define do
  sequence :title do |n|
    "Question #{n}"
  end

  sequence :body do |n|
    "Body #{n}"
  end

  factory :question do
    user
    title
    body
    factory :question_with_answers do
      transient do
        answers_count 5
      end
      after :create do |question, evaluator|
        FactoryGirl.create_list(:answer, evaluator.answers_count, question: question, user: evaluator.user)
      end
    end
    factory :question_with_attachments do
      transient do
        count 5
      end
      after :create do |question, evaluator|
        FactoryGirl.create_list(:attachment, evaluator.count, attachable: question)
      end
    end
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end