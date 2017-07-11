module OmniauthMacros
  def omniauth_mock
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:facebook, { uid: '12345', info: { email: "new@user.com" } })
    OmniAuth.config.mock_auth[:facebook]
  end
end