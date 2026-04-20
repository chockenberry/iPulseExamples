require 'uri'
require 'net/http'
require 'json'
require 'time'

# get the latest observations at Orange County Airport (SNA)
# the "KSNA" is a station identifier, which can be found on the NWS forecast page:
# https://forecast.weather.gov/MapClick.php?lat=33.678&lon=-117.8637
station_id = "KSNA"
url = URI("https://api.weather.gov/stations/#{station_id}/observations/latest")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(url)
request["accept"] = 'application/json'

response = http.request(request)

if response.code == "200"
	body = response.read_body
	
	begin
		json = JSON.parse(body)
		
		# save a copy of the output for debugging
		File.open("response.json", "w") do |file|
			file.puts JSON.pretty_generate(json)
		end
	
		properties = json["properties"]
	
		# format the observations
		formatted_header = properties["stationName"] || "Unknown"

		timestamp = properties["timestamp"]
		time = Time.parse(timestamp)
		formatted_time = time.getlocal.strftime("%-I:%M %p on %-m/%-d/%-Y")

		temperature = properties["temperature"]["value"]
		if temperature.nil?
			formatted_temperature = "N/A"
		else
			formatted_temperature = "%0.1f \'b0F" % ((temperature * 1.8) + 32) # convert from C to F with RTF escape
		end
		
		pressure = properties["barometricPressure"]["value"]
		if pressure.nil?
			formatted_pressure = "N/A"
		else
			formatted_pressure = "%0.1f mb" % (pressure / 100.0) # convert from Pa to mb
		end
		
		humidity = properties["relativeHumidity"]["value"]
		if humidity.nil?
			formatted_humidity = "N/A"
		else
			formatted_humidity = "%0.0f %%" % humidity
		end

		# update the template with formatted data
		template = File.read("template.rtf")
		
		template.sub!("[temperature]", formatted_temperature)
	
 		template.sub!("[pressure]", formatted_pressure)
 		template.sub!("[humidity]", formatted_humidity)
		
		template.sub!("[header]", formatted_header)
		template.sub!("[time]", formatted_time)
	
		puts template
	rescue JSON::ParserError => e
		puts "Failed to parse JSON: #{e.message}"
	end
	
else
	puts "Failed to load JSON"
end

