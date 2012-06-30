require 'open-uri'
require 'csv'
venue_data = open("http://www.ketlai.co.uk/venues.csv").read
CSV.parse(venue_data, :headers => true) do |row|
  begin
    Venue.create(
      :id => row['id'],
      :name => row['name'],
      :twitter => row['twitter'],
      :website => row['website'],
      :phone => row['phone'], 
      :picture => row['picture']
    )
  rescue DataObjects::IntegrityError
  end
end

event_data = open("http://www.ketlai.co.uk/events.csv").read
CSV.parse(event_data, :headers => true) do |row|
  begin
    Event.create!(
      :id => row['id'],
      :title => row['title'], 
      :description => row['description'][0..40],
      :startdate => row['startdate'],
      :enddate => row['enddate'],
      :city => row['city'],  
      :url => row['url'],   
      :picture => row['picture'],
      :venue_id => row['venue_id']
    )
  rescue DataObjects::IntegrityError
  end
end
