ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "mocha/minitest"
require "capybara/rails"
require "capybara/minitest"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)
  VCR.configure do |config|
    config.cassette_library_dir = "vcr_cassettes"
    config.hook_into :webmock
    config.filter_sensitive_data("<PASSWORD>") do |interaction|
      interaction.request.headers["Authorization"].first
    end
  end
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  # Make `assert_*` methods behave like Minitest assertions
  include Capybara::Minitest::Assertions

  # Reset sessions and driver between tests
  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
