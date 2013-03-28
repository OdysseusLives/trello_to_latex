require "rubygems"
require "json"

class Grouping
  def initialize(parsed_json)
  	@parsed = parsed_json
  end

  def formatsGroup(title, *desired_qualities)
  	message = "#{title}\n"
  	qualities_count = 1
  	if validTitle?(title)
	  	@parsed[title].each do |key, value|
	  		if value!= "" then 
	  			message << formatsOneQuality(key, value, qualities_count, *desired_qualities)
	  			qualities_count += 1
	  		end
	  	end
  	else
  		message = failedTitleMessage(title)
  	end
  	return message
	end

	def failedTitleMessage(title)
		return "There are no qualities associated with #{title}"
	end

	def validTitle?(title)
		return @parsed[title] != nil ? true : false
	end

	def formatsOneQuality(key, value, qualities_count, *desired_qualities)
		message = ""
			message = "   #{qualities_count}. #{key}: #{value}\n"
		return message
	end

	def formatsReference
			message = "Reference for colored labels:\n"
			formatsGroup("labelNames")
			return message
	end
end
