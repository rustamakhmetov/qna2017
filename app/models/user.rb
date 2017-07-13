class User < ApplicationRecord
  TEMP_EMAIL_PREFIX = 'qna2017@me'
  TEMP_EMAIL_REGEX = /\Aqna2017@me/

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]


  def author_of?(model)
    model.user_id == id if model.respond_to?(:user_id)
  end

  def self.find_for_omniauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid).first
    return authorization.user if authorization
    email = auth.info.email.nil? || auth.info.email.empty? ? create_temp_email(auth) : auth.info.email
    user = User.where(email: email).first
    unless user
      password = Devise.friendly_token[0,20]
      user = User.new(email: email, password: password, password_confirmation: password)
      if user.temp_email?
        user.skip_confirmation!
      end
      user.save
    end
    user.authorizations.create(provider: auth.provider, uid: auth.uid)
    user
  end

  def self.create_temp_email(auth)
    "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com"
  end

  def email_verified?
    !(self.email.empty? || temp_email?)
  end

  def temp_email?
    self.email.match?(TEMP_EMAIL_REGEX)
  end
end
