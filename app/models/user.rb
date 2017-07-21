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
    user.create_authorization(auth)
    user
  end

  def self.send_daily_digest
    find_each.each do |user|
      DailyMailer.delay.digest(user)
    end
  end

  def self.create_temp_email(auth)
    "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com"
  end

  def email_verified?
    !(self.email.empty? || temp_email?) && confirmed?
  end

  def temp_email?
    self.email.match?(TEMP_EMAIL_REGEX)
  end

  def update_email(params)
    if update(params.merge(confirmed_at: nil))
      send_confirmation_instructions
      yield if block_given?
    end
  end

  def move_authorizations(user)
    if user
      user.authorizations.each do |authorization|
        self.authorizations.create(authorization.attributes.except("id", "created_at",
                                                                            "updated_at"))
      end
      user.destroy!
      yield if block_given?
    end
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def update_params(params)
    email = params[:email]
    user = User.find_by_email(email)
    if user
      user.move_authorizations(self) do
        return {status: :existing, user: user }
      end
    else
      self.update_email(params) do
        return {status: :new, user: self }
      end
    end
  end
end
