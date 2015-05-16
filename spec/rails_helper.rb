# require 'simplecov'
# SimpleCov.start

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

require 'capybara/rspec'
require 'capybara/webkit/matchers'
require 'factory_girl_rails'
require 'omniauth'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |file| require file }

ActiveRecord::Migration.maintain_test_schema!

# $original_sunspot_session = Sunspot.session

RSpec.configure do |config|

  config.fixture_path = "#{::Rails.root}/spec/fixtures"


  config.infer_spec_type_from_file_location!


  # =================
  # JAVASCRIPT CONFIG
  # =================
  Capybara.javascript_driver = :webkit

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
  config.include CapybaraHelpers, type: :feature

  # ===================
  # Carrierwave cleanup
  # ===================
  config.after(:suite) do |config|
   if Rails.env.test? || Rails.env.cucumber?
     Rails.logger.debug "DELETED SPEC PUBLIC FOLDER"
      FileUtils.rm_rf(Dir["#{Rails.root}/public/spec/"])
    end
  end

  # =====================
  # Sunspot Spec stubbing
  # =====================
  # config.before do
  #   Sunspot.session = Sunspot::Rails::StubSessionProxy.new($original_sunspot_session)
  # end

  # config.before :each, solr: true do
  #   Sunspot::Rails::Tester.start_original_sunspot_session
  #   Sunspot.session = $original_sunspot_session
  #   Sunspot.remove_all!
  # end
end
