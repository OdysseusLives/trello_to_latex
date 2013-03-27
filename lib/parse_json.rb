require "rubygems"
require "json"

# Read JSON from a file, iterate over objects
file = open("input/one_card_section.json")
json = file.read

parsed = JSON.parse(json)
@tags = JSON.parse( json )["cards"]
@tags.each do |item| 
  puts "Card name: #{item["name"]}"
  # puts "All items: #{item}"
  puts "URL: #{item["url"]}"
end

@colored_labels = JSON.parse(json)["labelNames"]
puts "\nReference for colored labels:"
@colored_labels.each do |key, value| 
	if value != "" then 
		puts "The color #{key} indicates #{value}"
	end
end