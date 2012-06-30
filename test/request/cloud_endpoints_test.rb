require 'test_helper'

class CloudEndpointsTest < LocaCloudApiTest
  def test_meta_returns_json
    get "/bergcloud/meta.json"
    assert last_response.ok?, "Request failed: #{last_response.inspect}"
    assert_equal 'LocaLondon', JSON.parse(last_response.body)['name']
  end

  def test_can_get_icon
    get "/bergcloud/icon.png"
    assert last_response.ok?
  end

  def test_can_get_sample_publication
    get "/bergcloud/sample/"
    assert last_response.ok?
  end

  def test_can_get_sample_publication_without_slash
    get "/bergcloud/sample"
    assert last_response.ok?
  end

  def test_can_get_edition
    get "/bergcloud/edition"
    assert last_response.ok?
  end
end