ENV["RAILS_ENV"] ||= 'test'
#require 'rspec/rails'

require 'factory_girl_rails'
require 'capybara/rspec'
require 'capybara/webkit/matchers'
require 'omniauth'
require 'helpers/authentication_helpers.rb'

RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end


  # =================
  # JAVASCRIPT CONFIG
  # =================
  Capybara.javascript_driver = :webkit

  # ================
  # Database Cleaner
  # ================
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # ===============
  # Syntax Includes
  # ===============
  config.include(Capybara::Webkit::RspecMatchers, :type => :feature)
  config.include FactoryGirl::Syntax::Methods

  # ===============
  # OMNIAUTH CONFIG
  # ===============
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

  # =====================
  # Custom Helpers config
  # =====================
  config.include AuthenticationHelpers::Feature, type: :feature
  config.include AuthenticationHelpers::Controller, type: :controller

  # ===================
  # Carrierwave cleanup
  # ===================
  config.after(:each) do |config|
   if Rails.env.test? || Rails.env.cucumber?
      FileUtils.rm_rf(Dir["#{Rails.root}/spec/support/uploads"])
    end
  end
end

