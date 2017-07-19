FactoryGirl.define do

  factory :answer do
    user
    question
    body
    accept false
    rating 2

    factory :answer_with_attachments do
      transient do
        count 5
      end
      after :create do |answer, evaluator|
        FactoryGirl.create_list(:attachment, evaluator.count, attachable: answer)
      end
    end
  end

  factory :invalid_answer, class: "Answer" do
    user nil
    question nil
    body nil
  end

end
