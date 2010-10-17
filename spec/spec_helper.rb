# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = 'test'

require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'spec/autorun'
require 'spec/rails'

require 'rspec_response_enhancer'
require 'rspec_rails_mocha'
require 'webrat'

require "email_spec/helpers"
require "email_spec/matchers"

require 'ap'

include AuthenticatedTestHelper
include AuthenticatedSystem

# quiets the following ActiveRecord version 2.3.2 deprecation warning
# DEPRECATION WARNING: using %s in messages is deprecated; use {{value}} instead.. (called from 
# interpolate at /opt/local/lib/ruby/gems/1.8/gems/activerecord-2.3.2/lib/active_record/
# i18n_interpolation_deprecation.rb:17)
ActiveSupport::Deprecation.silenced = true

# Require all .rb files in /spec/shared and its sub-directories
Dir[RAILS_ROOT + '/spec/shared/**/*.rb'].each { |f| require f }

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  
  config.include RSpecResponseEnhancer
  config.include FixtureReplacement
  config.include Webrat::Matchers, :type => :views
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  # 
  # For more information take a look at Spec::Runner::Configuration and Spec::Runner
end

def mock_ticket
  mock_model(Ticket, :id => 1,
    :email  => 'email@example.com',
    :description => 'description that is long enough',
    :domain_name => 'example.com',
    :first_name => 'first name',
    :last_name => 'last name',
    :cpanel_username => 'cpanel name',
    :cpanel_password => 'cpanel password',
    :department => 'department',
    :to_xml => "User-in-XML", :to_json => "User-in-JSON", 
    :errors => [])
end

def smart_ap(data, html = true)
  puts '<pre>' if html == true
  ap data
  puts '</pre>' if html == true
end

# See http://www.blognow.com.au/q/67540/Reflect_on_association_one_liner_to_check_association_details.html
module ActiveRecord
    module Reflection
      class AssociationReflection
        def to_hash
          {
            :macro      => @macro,
            :class_name => @class_name || @name.to_s.singularize.camelize
          }
        end
      end
    end
  end