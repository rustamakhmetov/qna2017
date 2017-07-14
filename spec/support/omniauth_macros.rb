module OmniauthMacros
  def omniauth_mock(provider, **args)
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(provider, { uid: args[:uid] ? args[:uid] : '12345',
                                         info: {
                                             email: args[:email] ? args[:email] : "new@user.com"
                                         }
    })
    OmniAuth.config.mock_auth[provider]
  end
end