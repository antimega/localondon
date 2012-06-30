require 'test_helper'

class AdminRequestTest < LocaCloudApiTest
  def test_renders_new_venue_form
    get "/admin/venues/new"
    assert last_response.ok?, "Request failed: #{last_response.inspect}"
  end
end