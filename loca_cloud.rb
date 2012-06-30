#!/usr/bin/env ruby

require "rubygems"
require "sinatra"
require 'json'

get "/meta.json" do
  #"Publications describe themselves to BERG Cloud using the JSON contained in meta.json. edition"
  content_type :json
  {
    "name" => "LocaLondon",
    "description" => "Stuff that's going on",
    "delivered_on" => "every day",
    "external_configuration" => "false",
    "send_timezone_info" => "false",
    "send_delivery_count" =>  "false",
  }.to_json
end


get "/edition/" do
  # "Returns the version of this publication for this time. Configuration options (if any) are passed in along with timezone information (if requested by the publication)"
end



get "/sample/" do
  # "Returns sample content for the users wishing to test this publication without setting up a subscription icon  "
end

get "/icon.png" do
  # "An icon to show in to publications list on BERG Cloud"
end

post "/validate_config/" do
  # "Optional This endpoint is only required if your publication is configurable by the subscriber (for example a postcode if your pub was a daily weather forecast). The user input will be passed here for you to validate when the subscription is being created."
end

post "/configure/" do
  # "Optional If your publication requires the user to authenticate with a third party (e.g. Foursquare, for a publication showing recent checkins), set "external_config":"true" in meta.json and add the code to redirect to the third party at this endpoint"
end