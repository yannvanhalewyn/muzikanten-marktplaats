module AuthenticationHelpers

  module Feature
    def sign_in user
      omniauth_hash = {
        provider: user.provider,
        uid: user.uid,
        info: {
          name: user.name,
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email,
          imgage: user.image,
          urls: {
            Facebook: user.fb_profile_url
          }
        },
        credentials: {
          token: user.oauth_token,
          expires_at: user.oauth_expires_at
        }
      }
      OmniAuth.config.add_mock(:facebook, omniauth_hash)
      visit '/auth/facebook/callback'
    end
  end

  module Controller

  end
end
