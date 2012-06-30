require File.expand_path('../localondon', File.dirname(__FILE__))

require 'test/unit'
require 'rack/test'
require 'mocha'
ENV['RACK_ENV'] = 'test'

class LocaCloudApiTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end