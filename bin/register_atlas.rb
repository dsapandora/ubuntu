#!/usr/bin/ruby
require 'json'
require 'net/http'

ATLAS_API           = '/api/v1'
DISTRIBUTION_SERVER = 'http://dist.nerc-lancaster.ac.uk'
DETAILS             = JSON.parse(File.read('atlas.json'))
VERSION             = File.read('VERSION').strip
CHANGELOG           = `awk '/## #{VERSION}/{flag=1;next}/##/{flag=0}flag' CHANGELOG.md`

ATLAS_PROVIDERS     = {
  'vmware'     => 'vmware_desktop',
  'virtualbox' => 'virtualbox'
}

# Get the location where the box will be hosted. We will use the CEH Lancaster
# Distribution Server by default
def get_box_url(box)
  path = box.sub(/^box/, 'boxes')
  return "#{DISTRIBUTION_SERVER}/#{path}"
end

# Returns the details of the box for the given name. If we don't know 
# what this box is then we return nil
def get_box_details(name)
  DETAILS.select { |d| name.start_with?(d['prefix']) }.first
end

# Locate the list of boxes which have been created that should be registered to 
# the vagrant cloud
def get_built_boxes()
  Dir.glob("box/**/*-#{VERSION}.box").map { |b| {
    'provider' => ATLAS_PROVIDERS[b.split('/')[1]], 
    'box'      => File.basename(b, "-#{VERSION}.box"),
    'url'      => get_box_url(b)
  }}.select {|b| b['provider']} # Remove unknown providers
end

# Create or update a resource on atlas.
def create_or_update(create_uri, resource_uri, data)
  http = Net::HTTP.new('atlas.hashicorp.com', 443)
  http.use_ssl = true
  data['access_token'] = ENV['ATLAS_TOKEN'] # Set the access token
  
  # Test to see if the resource already exists. It it does, will will update,
  # otherwise we will create
  res = http.request_get("#{ATLAS_API}/#{resource_uri}")
  req = case res.code
  when '404' then Net::HTTP::Post.new("#{ATLAS_API}/#{create_uri}")
  when '200' then Net::HTTP::Put.new("#{ATLAS_API}/#{resource_uri}")
  else 
    raise "Unknown HTTP status #{resource_uri}: #{res.code} #{res.body}"
  end

  req.set_form_data(data)    # Set the data for the request
  update = http.request(req) # Perform the update/creation
  if update.code != '200'    # Make sure that the status code was 200
    raise "Unknown HTTP status #{resource_uri}: #{update.code} #{update.body}"
  end
  puts "Updated: #{resource_uri}"
end

# Interact with the Atlas rest api to register the built box. The boxes
# should already have been moved to the correct location on the Distribution
# Server.
get_built_boxes()
  .group_by {|b| b['box']}
  .map      {|k,v| { 'details' => get_box_details(k), 'providers' => v }}
  .select   {|b| b['details']} # Remove unknown providers
  .each     {|box|
    boxname = "box/nercceh/#{box['details']['name']}"
    version = "#{boxname}/version/#{VERSION}"

    create_or_update('boxes', boxname, {
      'box[name]'              => box['details']['name'],
      'box[description]'       => box['details']['description'],
      'box[short_description]' => box['details']['short_description'],
      'box[is_private]'        => false
    })

    create_or_update("#{boxname}/versions", "#{boxname}/version/#{VERSION}", {
      'version[version]'     => VERSION,
      'version[description]' => CHANGELOG
    })

    box['providers'].each {|p|
      create_or_update("#{version}/providers", "#{version}/provider/#{p['provider']}", {
        'provider[name]' => p['provider'],
        'provider[url]'  => p['url']
      })
    }
  }