require 'simplecov'
SimpleCov.start 'rails' do
  # exclude coverage
  add_filter 'app/channels'
  add_filter 'app/helpers'
  add_filter 'app/mailers'
  add_filter 'app/jobs'
  add_filter 'app/resources'
  add_filter 'vendor/'
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'webmock/rspec'



RSpec.configure do |config|
  # Ensure API security is disabled for tests unless explicitly needed
  ENV["API_GATEWAY_KEY"] = nil
  ENV["USERS_API_GATEWAY_KEY"] = nil
  ENV["API_PAYLOAD_ENCRYPTION_ENABLED"] = "false" 
 
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end

ActiveJob::Base.queue_adapter = :test
