# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'spec/autorun'
require 'spec/rails'
require File.expand_path(File.dirname(__FILE__) + "/blueprints")

Webrat.configure do |config|
  config.mode = :rails
end

module Spec::Rails::Example
  class IntegrationExampleGroup < ActionController::IntegrationTest

   def initialize(defined_description, options={}, &implementation)
     defined_description.instance_eval do
       def to_s
         self
       end
     end

     super(defined_description)
   end

    Spec::Example::ExampleGroupFactory.register(:integration, self)
  end
end

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  #config.use_transactional_fixtures = true
  #config.use_instantiated_fixtures  = false
  #config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

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
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  #
  # For more information take a look at Spec::Runner::Configuration and Spec::Runner

  config.before(:each) { Sham.reset }
end

# Borrowed from mislav's tip over at StackOverflow:
# http://stackoverflow.com/questions/64827
module AuthHelper
  protected

  def login_as(model, id_or_attributes = {})
    attributes = id_or_attributes.is_a?(Fixnum) ? {:id => id} : id_or_attributes
    @current_user = stub_model(model, attributes)
    target = controller rescue template
    target.instance_variable_set '@current_user', @current_user

    if block_given?
      yield
      target.instance_variable_set '@current_user', nil
    end
    return @current_user
  end

  def login_as_user(id_or_attributes = {}, &block)
    login_as(User, id_or_attributes, &block)
  end
end

module WebratHelpers
  def login_with_valid_credentials
    fill_in "login", :with => "john"
    fill_in "password", :with => "test"
    click_button "login"
  end
end
