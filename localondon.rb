#!/usr/bin/env ruby

require "rubygems"
require "sinatra"
require "data_mapper"
require "haml"
require 'sinatra/contrib/all'
require 'dm-geokit'
require 'dm-aggregates'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/localondon.db")

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
