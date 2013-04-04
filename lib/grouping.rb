require "rubygems"
require "json"

class Grouping
	attr_reader :parsed, :title
  
  def initialize(parsed_json)
  	@parsed = parsed_json
  end

  def returnsInformationUsingConfig(line)
  	@title = line[0]
  	*desired_qualities = line[1, line.length]
  	return returnsInformation(@title, *desired_qualities) 
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
		if isAKeyValuePair?(title) # This seems fragile. 
			return formatsOneKeyValuePair(title)
		else
			return setupOneMessageBodySection(title, qualities_location, *desired_qualities)
		end
	end

  def setupOneMessageBodySection(title, qualities_location, *desired_qualities)
  	message = ""
  	qualities_count = 1
  	qualities_location.each do |key, value|
  		if doIOutputAMessage?(key, value, *desired_qualities)
  			message << formatsOneQuality(key, value, qualities_count) 
  			qualities_count += 1 
  		end
  	end
  	return message
	end

  def doIOutputAMessage?(key, value, *desired_qualities)
  	if value != ""
  		areThereDesiredQualities?(*desired_qualities) ? (validKey?(key, *desired_qualities) ? true : false ) : true
  	else
  		return false
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

	def formatsOneQuality(key, value, qualities_count)
		return "   #{qualities_count}. #{key}: #{value}\n"
	end

	def formatsOneKeyValuePair(title)
		return "      #{title}: #{@parsed[title]}\n"
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

	def isAKeyValuePair?(title)
		container = @parsed.to_s
		puts "C: #{container}" if title == "language"
		# if isLastItemInContainer?(title, container)
		# 	regular string search
		# else
		# 	search until next item in container, be it ', "' or '=>'
		# end
		begin_search = container.index(title) + title.length
		firstArrowAfterTitle = container[begin_search, container.length].index("=>{")
		if firstArrowAfterTitle != nil 
			secondArrowAfterTitle = container[firstArrowAfterTitle + 2, container.length - 1].index("=>")
			return secondArrowAfterTitle == nil ? true : false
		else
			return true
		end
	end

end
