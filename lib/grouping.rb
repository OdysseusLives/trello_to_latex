require "rubygems"
require "json"

class Grouping
	attr_reader :parsed
  
  def initialize(parsed_json)
  	@parsed = parsed_json
  end

  def formatsOneGroup(title, *desired_qualities)
  	message = "#{title}\n"

  	if groupIsHidingInAnArray?(title) then
  		@parsed[title].each do |item|
  			qualities_location = item
  			message << formatsOneSubGroup(title, qualities_location, *desired_qualities)
  		end
  	else
  		qualities_location = @parsed[title]
  		message << formatsOneSubGroup(title, qualities_location, *desired_qualities)
  	end
  	message << "\n"
  	return message
  end

  def formatsOneSubGroup(title, qualities_location, *desired_qualities)
  	message = "" 
  	qualities_count = 1
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
			message << formatsOneGroup("labelNames")
			return message
	end

	def isAnArray?(title)
		@parsed[title].kind_of?(Array) ? true : false
	end

	def isAnObject?(title)
		!@parsed[title].kind_of?(Array) && !@parsed[title].kind_of?(Hash) ? true : false
	end

	def isAHash?(title)
		@parsed[title].kind_of?(Hash) ? true : false
	end

end
