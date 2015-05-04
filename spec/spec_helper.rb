require 'factory_girl_rails'
require 'omniauth'
require 'helpers/authentication_helpers.rb'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end


  config.include FactoryGirl::Syntax::Methods

  # Configure omniauth
  RACK_ENV = ENV['ENVIRONMENT'] ||= 'test'
  OmniAuth.config.test_mode = true
  omniauth_hash = {
    provider: "facebook",
    uid: "1234",
    info: {
      name: "John Doe",
      first_name: "John",
      last_name: "Doe",
      email: "johndoe@email.com",
      imgage: "link_to_image.jpg",
      urls: {
        Facebook: "http://www.facebook.com/john.doe"
      }
    },
    credentials: {
      token: "testtoken1234tsdf",
      expires_at: 30.days.from_now
    }
  }
  OmniAuth.config.add_mock(:facebook, omniauth_hash)
  OmniAuth.config.on_failure = Proc.new { |env|
    OmniAuth::FailureEndpoint.new(env).redirect_to_failure
  }

  config.include AuthenticationHelpers::Feature, type: :feature
  config.include AuthenticationHelpers::Controller, type: :controller

  # Delete saved carrierwave images after each test
  config.after(:each) do |config|
   if Rails.env.test? || Rails.env.cucumber?
      FileUtils.rm_rf(Dir["#{Rails.root}/spec/support/uploads"])
    end
  end
end

