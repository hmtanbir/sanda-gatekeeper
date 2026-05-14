source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.3"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# json web token
gem "jwt"
gem "faraday"
gem "faraday-multipart"


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem "rack-cors"


# I18n support
gem "rails-i18n"

# redis support
gem "redis"


# env support
gem "dotenv-rails"

group :development do
  gem "pry-rails"
end

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
  gem "mutex_m", require: false
end

group :test do
  gem "rails-controller-testing"
  gem "rspec-rails"
  gem "simplecov", require: false
  gem "shoulda-matchers"
  gem "webmock"
end

gem "rswag-api", "~> 2.17"
gem "rswag-ui", "~> 2.17"
gem "rswag-specs", "~> 2.17"
