require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy)}
  it { should have_many(:answers).dependent(:destroy)}
  it { should validate_presence_of :email}
  it { should validate_presence_of :password}

  describe 'method author_of?' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }

    context 'with valid attributes'  do
      it 'author of Answer' do
        expect(user).to be_author_of(create(:answer, user: user))
      end

      it 'non-author of Answer' do
        expect(user).to_not be_author_of(answer)
      end
    end

    context 'with invalid attributes'  do
      it 'Answer with nil user_id' do
        answer.user_id = nil
        expect(user).to_not be_author_of(answer)
      end

      it 'model is nil' do
        expect(user).to_not be_author_of(nil)
      end

      it 'fake model without field user_id' do
        expect(user).to_not be_author_of("")
      end
    end
  end

end
