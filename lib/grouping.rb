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
		start_point = startPointAfterTitle(title, container, 0)
		features = ["=>", ",", "{"]
		end_points = []
		end_points[0] = container.length
		counter = 1
		end_points = searchForFeature(title, container, start_point, features, end_points, counter) 
		return hasNoWords?(container, start_point, end_points) ? false : true
	end

	def hasNoWords?(container, start_point, end_points)
		counter = 0
		end_points.each { |end_point| 
			if end_point < start_point then
				return true 
			else
				return true if %r{\w}.match(container[start_point..end_points[counter]]) == nil 
			end
			counter += 1
		}
		return false
	end

	def searchForFeature(title, container, start_point, features, end_points, counter) 
		features.each { |feature| 
			end_points[counter] = updateEndPoint(container, start_point, end_points[counter - 1], feature)
			counter += 1
		} 
		end_points
	end

	def hasAFeature?(container, start_point, end_point, feature)
		container[start_point..end_point].index(feature) != nil ? true : false
	end

	def hereIsThisFeature(container, start_point, end_point, feature)
		return container[start_point..end_point].index(feature) != nil ? container[start_point..end_point].index(feature) - 1 : nil
	end

	def startPointAfterTitle(title, container, start_point)
		start_point = findTitle(title, container, start_point)
		if isTitleATitleAndNotAnAttribute?(title, container, start_point)
			return start_point + title.length + "\"=>".length 
		else
			startPointAfterTitle(title, container, start_point + title.length + "\"=>".length )
		end
	end

	def findTitle(title, container, start_of_title)
		container[start_of_title..container.length].index(title) + start_of_title
	end

	def isTitleATitleAndNotAnAttribute?(title, container, start_point)
		if container[start_point - 1] == "\"" then 
			if container[start_point + title.length] == "\"" then 
				if container[start_point - 3..start_point -2] != "=>" then 
					return true
				end
			end
		end
		return false
	end

	def updateEndPoint(container, start_point, end_point, feature)
		add_to_start_point = 0 
		if hasAFeature?(container, start_point, end_point, feature) == true then 
			add_to_start_point = hereIsThisFeature(container, start_point, end_point, feature) 
			end_point = start_point + add_to_start_point
		end
		return end_point
	end

end
