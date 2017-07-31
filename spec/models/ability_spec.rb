require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user)}

  describe "for guest" do
    let(:user) { nil }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  describe "for admin" do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all}
  end

  describe "for user" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other_user) }
    let(:answer) { create(:answer, user: user) }
    let(:other_answer) { create(:answer, user: other_user) }
    let(:subscription) { user.subscribe(question) }
    let(:other_subscription1) { other_user.subscribe(question) }
    let(:other_subscription2) { user.subscribe(other_question) }
    let(:other_subscription3) { other_user.subscribe(other_question) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :manage, Vote }

    it { should be_able_to :manage, create(:attachment, attachable: question, attachable_type: "Question") }
    it { should_not be_able_to :manage, create(:attachment, attachable: other_question, attachable_type: "Question") }
    it { should be_able_to :manage, create(:attachment, attachable: answer, attachable_type: "Answer") }
    it { should_not be_able_to :manage, create(:attachment, attachable: other_answer, attachable_type: "Answer") }


    it { should be_able_to :manage, Authorization }

    it { should be_able_to :vote_up, other_question }
    it { should_not be_able_to :vote_up, question }

    it { should be_able_to :vote_up, other_answer }
    it { should_not be_able_to :vote_up, answer }

    it { should be_able_to :vote_down, other_question }
    it { should_not be_able_to :vote_down, question }

    it { should be_able_to :vote_down, other_answer }
    it { should_not be_able_to :vote_down, answer }


    it { should be_able_to [:update, :destroy, :edit], question }
    it { should_not be_able_to [:update, :destroy, :edit], other_question }

    it { should be_able_to [:update, :destroy, :edit], answer }
    it { should_not be_able_to [:update, :destroy, :edit], other_answer }

    it { should be_able_to [:update, :destroy], create(:comment, commentable: question,
                                           commentable_type: "Question", user: user) }
    it { should_not be_able_to [:update, :destroy], create(:comment, commentable: question,
                                           commentable_type: "Question", user: other_user) }

    it { should be_able_to :accept, create(:answer, question: question) }
    it { should_not be_able_to :accept, create(:answer, question: question, accept: true) }
    it { should_not be_able_to :accept, create(:answer, question: other_question) }

    it { should be_able_to :create, subscription }
    it { should be_able_to :destroy, subscription }
    it { should_not be_able_to :destroy, other_subscription1 }
    it { should_not be_able_to :destroy, other_subscription2 }
    it { should_not be_able_to :destroy, other_subscription3 }
  end
end