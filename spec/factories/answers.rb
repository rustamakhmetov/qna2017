FactoryGirl.define do
  factory :answer do
    user
    question
    body "MyString"
  end

  factory :invalid_answer, class: "Answer" do
    user nil
    question nil
    body nil
  end

end
