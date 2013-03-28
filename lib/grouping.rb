require "rubygems"
require "json"

class Grouping
  def initialize(parsed_json)
  	@parsed = parsed_json
  end

  def formatsGroup(title, *desired_qualities)
  	message = "#{title}\n"
  	qualities_count = 1

  	groupIsHidingInAnArray?(title) ? qualities_location = @parsed[title][0] : qualities_location = @parsed[title]
  	
  	if validTitle?(title)
	  	qualities_location.each do |key, value|
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

	def groupIsHidingInAnArray?(title)
		@parsed[title].kind_of?(Array) ? true : false
	end

	def failedTitleMessage(title)
		return "There are no qualities associated with #{title}"
	end

	def validTitle?(title)
		return @parsed[title] != nil ? true : false
	end

	def formatsOneQuality(key, value, qualities_count, *desired_qualities)
		return "   #{qualities_count}. #{key}: #{value}\n"
	end

	def formatsReferenceForColoredLabels
			message = "Reference for colored labels:\n"
			message << formatsGroup("labelNames")
			message << "\n"
			return message
	end
end
