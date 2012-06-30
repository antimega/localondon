require 'loca_cloud'

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