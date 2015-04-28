module AuthenticationHelpers

  def self.user_to_aouth_hash user
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
  end

  module Feature
    def sign_in user
      auth_hash = AuthenticationHelpers::user_to_aouth_hash user
      OmniAuth.config.add_mock(:facebook, auth_hash)
      visit '/auth/facebook/callback'
    end
  end

  module Controller
    def sign_in user
      allow(controller).to receive(:current_user).and_return(user)
    end
  end
end
