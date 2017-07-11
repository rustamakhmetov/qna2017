require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy)}
  it { should have_many(:answers).dependent(:destroy)}
  it { should have_many(:authorizations).dependent(:destroy)}
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

  describe ".find_for_oauth" do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "123456") }

    context "user already has authorization" do
      it "returns the user" do
        user.authorizations.create(provider: auth.provider, uid: auth.uid)
        expect(User.find_for_omniauth(auth)).to eq user
      end
    end

    context "user has not authorization" do
      context "user already exists" do
        let(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "123456", info: { email: user.email })}

        it "does not create new user" do
          expect{ User.find_for_omniauth(auth) }.to_not change(User, :count)
        end

        it "creates new record for authorization" do
          expect{ User.find_for_omniauth(auth) }.to change(Authorization, :count).by(1)
        end

        it "creates authorization with provider and uid" do
          authorization = User.find_for_omniauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it "returns the user" do
          expect(User.find_for_omniauth(auth)).to be_a(User)
        end
      end

      context "user does not exists" do
        let(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "123456", info: { email: "new@user.com" })}

        it "create new record user" do
          expect{ User.find_for_omniauth(auth) }.to change(User, :count).by(1)
        end

        it "returns new user" do
          expect(User.find_for_omniauth(auth)).to be_a(User)
        end

        it "fills user email" do
          user = User.find_for_omniauth(auth)
          expect(user.email).to eq auth.info.email
        end

        it "creates new record for authorization" do
          expect{ User.find_for_omniauth(auth) }.to change(Authorization, :count).by(1)
        end

        it "creates authorization with provider and uid" do
          authorization = User.find_for_omniauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

end
