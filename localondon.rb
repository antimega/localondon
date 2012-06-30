#!/usr/bin/env ruby

require "rubygems"
require "sinatra"
require "data_mapper"
require "haml"
require 'sinatra/contrib/all'
require 'dm-geokit'
require 'dm-aggregates'
require 'json'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/localondon.db")

class Event
  include DataMapper::Resource
	property :id,		Serial
	property :title,	String
	property :description,	Text
	property :startdate,	Date
	property :enddate,	Date
	property :city, 	String
	property :url,        String
	property :picture, Text
	belongs_to :venue
end


class Venue
  include DataMapper::Resource
  include DataMapper::GeoKit
	property :id,		Serial
	property :name,	String
	property :twitter, String
	property :website, Text
	property :phone, String
	property :picture, Text
  has_geographic_location :address
  has n, :events
end

DataMapper.finalize
DataMapper.auto_upgrade!

require 'import'

get "/admin" do
	Venue.get(1).title
end

# Show list of venues
get '/admin/venues' do
	haml :venuelist, :locals => { :cs => Venue.all }
end

# Show form to create new venue
get '/admin/venues/new' do
	haml :venueform, :locals => {
 		:c => Venue.new,
 		:action => '/venues/create'
	}
end

# Create new venue
post '/admin/venues/create' do
	c = Venue.new
	c.attributes = params
	c.save

	redirect("/venues/#{c.id}")
end

# Show form to edit venue
get '/admin/venues/:id/edit' do|id|
	c = Venue.get(id)
	haml :venueform, :locals => {
	 	:c => c,
	 	:action => "/venues/#{c.id}/update"
	}
end

# Edit a venue
post '/admin/venues/:id/update' do|id|
	c = Venue.get(id)
	c.update_attributes params

	redirect "/venues/#{id}"
end

# Delete a venue
post '/admin/venues/:id/destroy' do|id|
	c = Venue.get(id)
	c.destroy

	redirect "/venues/"
end

# View a venue
get '/admin/venues/:id' do|id|
	c = Venue.get(id)
	haml :venueshow, :locals => { :c => c }
end

# Routes for BERG Cloud.
# TODO: Consider making the different interfaces into modules or otherwise separating

# get "/bergcloud/meta.json" do
#   #"Publications describe themselves to BERG Cloud using the JSON contained in meta.json. edition"
#   content_type :json
#   {
#     "name" => "LocaLondon",
#     "description" => "Stuff that's going on",
#     "delivered_on" => "every day",
#     "external_configuration" => "false",
#     "send_timezone_info" => "false",
#     "send_delivery_count" =>  "false",
#   }.to_json
# end

get "/bergcloud/edition/?" do
  # "Returns the version of this publication for this time. Configuration options (if any) 
  # are passed in along with timezone information (if requested by the publication)"

  today = Time.now.strftime("%Y-%m-%d")
  end_of_week = (Time.now + 7*24*3600).strftime("%Y-%m-%d")

  @opening = Event.all(
    :startdate => (today..end_of_week)
  )
  @closing = Event.all(
    :enddate => (today..end_of_week)
  )

  etag "#{Time.now.to_s}"
  erb :edition
end

get '/bergcloud/sample/?' do
  # "Returns sample content for the users wishing to test this publication without setting 
  # up a subscription icon  "

  language = 'english'
  name = 'LocaLondon'
  # Set the etag to be this content
  etag Digest::MD5.hexdigest(language+name)
  erb :sample_publication
end

post "/bergcloud/validate_config/" do
  # "Optional This endpoint is only required if your publication is configurable by the
  # subscriber (for example a postcode if your pub was a daily weather forecast). The user
  # input will be passed here for you to validate when the subscription is being created."
  content_type :json
  {"valid" => true}.to_json
end

post "/bergcloud/configure/" do
  # "Optional If your publication requires the user to authenticate with a third party 
  # (e.g. Foursquare, for a publication showing recent checkins), set "external_config":"true" 
  # in meta.json and add the code to redirect to the third party at this endpoint"
end