FactoryGirl.define do
  factory :comment do
    user
    sequence(:body) { |n| "Comment body #{n}" }
  end

  factory :invalid_comment, class: "Comment" do
    user nil
    body nil
  end
end
