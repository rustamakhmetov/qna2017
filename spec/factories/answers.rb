FactoryGirl.define do

  factory :answer do
    user
    question
    body
  end

  factory :invalid_answer, class: "Answer" do
    user nil
    question nil
    body nil
  end

end
