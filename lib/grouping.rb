require "rubygems"
require "json"

class Grouping
  def initialize(parsed_json)
  	@parsed = parsed_json
  end

  def formatsGroup(title, *desired_qualities)
  	message = "#{title}\n"
  	qualities_count = 1

  	@parsed[title].each do |key, value|
  		# if key.kind_of?(Array) then 
  		# 	key.each do |new_key, value|
  		# 		message = formatsOneQuality(new_key, value, qualities_count, *desired_qualities)
  		# 	end
  		# else
  			message << formatsOneQuality(key, value, qualities_count, *desired_qualities)
  		# end
  	end
  	return message
	end

	def formatsOneQuality(key, value, qualities_count, *desired_qualities)
		message = ""
		if value!= "" then 
			message = "   #{qualities_count}. #{key}: #{value}\n"
			qualities_count += 1
		end
		return message
	end

	def formatsReference
			message = "Reference for colored labels:\n"
			formatsGroup("labelNames")
			return message
	end
end

# puts "Reference for colored labels:"
# parsed["labelNames"].each do |key, value| 
# 	if value != "" then 
# 		puts "   The color #{key} indicates #{value}"
# 	end
# end
# puts "\n"

# card_count = 1
# parsed["cards"].each do |item| 
# 	puts "Card #{card_count}"
#   puts "   Card name: #{item["name"]}"
#   puts "   URL: #{item["url"]}"
#   card_count += 1
# end

