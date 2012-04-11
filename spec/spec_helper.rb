ENV["RAILS_ENV"] ||= 'test'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'bundler'
require 'rspec'
require 'mobile_path'
require 'rails/all'
require 'rspec/rails'
require 'diesel/testing'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

class ApplicationController < ActionController::Base
  include MobilePath
end

RSpec.configure do |config|
end
