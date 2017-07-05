FactoryGirl.define do
  factory :comment do
    user
    body "comment's text"
  end

  factory :invalid_comment, class: "Comment" do
    user nil
    body nil
  end
end
