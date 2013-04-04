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
		return setupOneMessageBodySection(title, qualities_location, *desired_qualities)
	end

  def setupOneMessageBodySection(title, qualities_location, *desired_qualities)
  	message = ""
  	qualities_count = 1
  	qualities_location.each do |key, value|
  		message << loopThroughEachQualitiesLocation(title, qualities_location, key, value, qualities_count, *desired_qualities)
  		qualities_count += adjustQualitiesCount(key, value, *desired_qualities)
  	end
  	return message
	end

	def loopThroughEachQualitiesLocation(title, qualities_location, key, value, qualities_count, *desired_qualities) 
		message = ""
		if desired_qualities != []
			desired_qualities.each do |desired_key|
				if key == desired_key && value != "" then 
					message << formatsOneQuality(key, value, qualities_count, *desired_qualities) 
				end
			end
		else
  		if value!= "" then 
  			message << formatsOneQuality(key, value, qualities_count, *desired_qualities) 
  		end
  	end
  	return message
  end

  def adjustQualitiesCount(key, value, *desired_qualities)
  	if value != ""
  		areThereDesiredQualities?(*desired_qualities) ? (validKey?(key, *desired_qualities) ? 1 : 0 ) : 1
  	else
  		return 0
  	end
  end

  def areThereDesiredQualities?(*desired_qualities)
  	return desired_qualities != [] ? true : false
  end

  def validKey?(key, *desired_qualities)
  	desired_qualities.each { |desired_key| 
			return true if desired_key == key }
		return false
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
