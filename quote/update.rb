require 'uri'
require 'net/http'
require 'json'

url = URI("https://dummyjson.com/quotes/random")

#puts url

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
	
		quote = json["quote"]
		author = json["author"]
	
		# the information window can display 45 columns of plain text
		wrapped_quote = quote.scan(/.{1,45}(?:\s+|$)/).map(&:strip).join("\n")
		
		puts ""
		puts wrapped_quote
		puts ""
		puts "\t#{author}"
	rescue JSON::ParserError => e
		puts "Failed to parse JSON: #{e.message}"
	end
	
else
	puts "Failed to load JSON"
end

