# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true


# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

# Restful Authentication
REST_AUTH_SITE_KEY = 'f5945d1c74d3502f8a3de8562e5bf21fe3fec887'
REST_AUTH_DIGEST_STRETCHES = 10

# textmate footnotes for development
config.gem "rails-footnotes",  
        :lib => "rails-footnotes"

config.gem "awesome_print", :lib => false
require 'ap'

# http://github.com/ddollar/rack-debug
# config.gem 'rack-debug'
# config.middleware.use 'Rack::Debug'

if File.exists?(File.join(RAILS_ROOT,'tmp', 'debug.txt'))
  require 'ruby-debug'
  Debugger.wait_connection = true
  Debugger.start_remote
  File.delete(File.join(RAILS_ROOT,'tmp', 'debug.txt'))
end

config.after_initialize do
  ActiveMerchant::Billing::Base.gateway_mode = :test
end

class ActionMailer::Base
default_url_options[:host] = "localhost"
default_url_options[:port] = 3000
end
