require "rubygems"
require "json"

class Grouping
  def initialize(parsed_json)
  	@parsed = parsed_json
  end

  def formatsGroup(title, *desired_qualities)
  	message = "#{title}\n"
  	qualities_count = 1

  	qualities_location = groupIsHidingInAnArray?(title)
  	
  	if validTitle?(title)
	  	qualities_location.each do |key, value|
	  		if desired_qualities != []
	  			desired_qualities.each do |desired_key|
	  				if key == desired_key && value != "" then 
	  					message << formatsOneQuality(key, value, qualities_count, *desired_qualities) 
	  					qualities_count += 1 
	  				end
	  			end
	  		else
		  		if value!= "" then 
		  			message << formatsOneQuality(key, value, qualities_count, *desired_qualities) 
		  			qualities_count += 1 
		  		end
		  	end
	  	end
  	else
  		message = failedTitleMessage(title)
  	end
  	return message
	end

	def groupIsHidingInAnArray?(title)
		@parsed[title].kind_of?(Array) ? @parsed[title][0] : @parsed[title]
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
