require 'helpers/authentication_helpers.rb'
require 'helpers/capybara_helpers.rb'

RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # =====================
  # Custom Helpers config
  # =====================
  config.include AuthenticationHelpers::Feature, type: :feature
  config.include AuthenticationHelpers::Controller, type: :controller
  config.include CapybaraHelpers, type: :feature

  # don't run tests I marked broken
  config.filter_run_excluding :broken => true


end

