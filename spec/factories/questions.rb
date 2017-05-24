FactoryGirl.define do
  factory :question do
    title "Question 1"
    body "Body 1"
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end