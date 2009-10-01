# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

# Restful Authentication
REST_AUTH_SITE_KEY = 'f5945d1c74d3502f8a3de8562e5bf21fe3fec887'
REST_AUTH_DIGEST_STRETCHES = 10

# Specify gems that this application depends on in the *TEST* environment only
config.gem "aslakhellesoy-cucumber",
            :lib => "cucumber",
            :source => "http://gems.github.com"
            
config.gem 'webrat'
# david chelimsky says not to include them here
# config.gem "dchelimsky-rspec-rails",
#              :lib => "rspec-rails",
#              :source => "http://gems.github.com"
#  config.gem "dchelimsky-rspec",
#              :lib => "rspec",
#              :source => "http://gems.github.com"

config.after_initialize do
  ActiveMerchant::Billing::Base.gateway_mode = :test
end
