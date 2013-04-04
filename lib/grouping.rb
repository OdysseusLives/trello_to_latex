require "rubygems"
require "json"

class Grouping
	attr_reader :parsed
  
  def initialize(parsed_json)
  	@parsed = parsed_json
  end

  def returnsInformation(title, *desired_qualities)
  	return validTitle?(title) ? setupWholeMessage(title, *desired_qualities) : failedTitleMessage(title)
  end

  def setupWholeMessage(title, *desired_qualities)
  	message = "#{title}\n"
  	message << returnsMessageBody(title, *desired_qualities)
  	message << "\n"
  	return message
  end

  def returnsMessageBody(title, *desired_qualities)
  	if isAnArray?(title) then
  		message = loopInArrayToSetupMessageBody(title, *desired_qualities)
  	else
  		qualities_location = @parsed[title]
  		message = setupMessageBody(title, qualities_location, *desired_qualities)
  	end
  	return message
  end

  def loopInArrayToSetupMessageBody(title, *desired_qualities)
		message = ""
		@parsed[title].each do |item|
			qualities_location = item
			message << setupMessageBody(title, qualities_location, *desired_qualities)
		end
		return message
	end

	def setupMessageBody(title, qualities_location, *desired_qualities)
		return formatsOneSubGroup(title, qualities_location, *desired_qualities)
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
		message << setupWholeMessage("labelNames")
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

	def isAKeyValuePair?(statement)
		firstArrow = statement.to_s.index("=>")
		if firstArrow != nil 
			secondArrow = statement.to_s[firstArrow + 2, statement.to_s.length - 1].index("=>")
			return secondArrow == nil ? true : false
		else
			return false
		end
	end

end
