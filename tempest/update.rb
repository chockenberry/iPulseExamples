require 'uri'
require 'net/http'
require 'json'

# The API key (Personal Use Token) can be obtained from the Tempest website:
#	https://tempestwx.com/settings/tokens
#
# The station ID can be determined from here:
#	https://tempestwx.com/settings/stations/
# Each URL in the list ends with the id.
#
# The API documentation for the endpoint being used is here:
#	https://apidocs.tempestwx.com/reference/get_observations-stn-station-id

station_id = "YOUR-STATION-ID-HERE"
api_key = "YOUR-API-KEY-HERE"

url = URI("https://swd.weatherflow.com/swd/rest/observations/stn/#{station_id}?bucket=1&units_temp=f&units_wind=mph&units_pressure=mb&units_precip=in&units_distance=mi&ob_fields=air_temp,air_temp_today_high,air_temp_today_low,sea_level_pressure,uv,rh,precip_accumulation&api_key=#{api_key}")

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
	
		observations = json["obs"][0]

		# format the observations - note that indices of observations are based on ob_fields order in the request
		timestamp = observations[0]
		time = Time.at(timestamp)
		formatted_time = time.strftime("%-I:%M %p")

		temperature = observations[2]
		formatted_temperature = "%0.1f" % temperature
		
		pressure = observations[5]
		formatted_pressure = "%0.1f" % pressure
		humidity = observations[7]
		formatted_humidity = "%0.0f" % humidity
		rain = observations[8]
		formatted_rain = "%0.1f" % rain
		
		uv = observations[6]
		formatted_uv = "%0.1f" % uv


		# update the template with formatted data
		template = File.read("template.rtf")
		
		template.sub!("[temperature]", formatted_temperature)
	
		template.sub!("[pressure]", formatted_pressure)
		template.sub!("[humidity]", formatted_humidity)
		template.sub!("[rain]", formatted_rain)
	
		template.sub!("[uv]", formatted_uv)
		
		template.sub!("[time]", formatted_time)
	
		puts template
	rescue JSON::ParserError => e
		puts "Failed to parse JSON: #{e.message}"
	end
	
else
	puts "Failed to load JSON"
end

