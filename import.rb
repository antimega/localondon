require 'csv'
venue_data = open("http://jystewart.net/venues.csv").read
CSV.parse(venue_data, :headers => true) do |row|
  Venue.create(
    :id => row['id'],
    :name => row['name'],
    :twitter => row['twitter'],
    :website => row['website'],
    :phone => row['phone'], 
    :picture => row['picture']
  )
end

event_data = open("http://jystewart.net/events.csv").read
CSV.parse(event_data, :headers => true) do |row|
  Event.create(
    :id => row['id'],
    :title => row['title'], 
    :description => row['description'],
    :startdate => row['startdate'],
    :enddate => row['enddate'],
    :city => row['city'],  
    :url => row['url'],   
    :picture => row['picture']
  )
end
