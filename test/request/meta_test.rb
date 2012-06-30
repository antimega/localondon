require 'test_helper'

class ArtefactRequestTest < LocaCloudApiTest
  def test_returns_json
    get "/meta.json"
    assert last_response.ok?, "Request failed: #{last_response.inspect}"
    assert_equal 'LocaLondon', JSON.parse(last_response.body)['name']
  end
end