require "rubygems"
require "json"

class Intro
	# attr_reader
  
  # def initialize(parsed_json)
  # 	@parsed = parsed_json
  # end

  def keys_to_symbol(h)
    new_hash = {}
    h.each do |k,v|
      if v.class == String || v.class == Fixnum || v.class == Float
        new_hash[k] = v
      elsif v.class == Hash
        new_hash[k] = keys_to_symbol(v)
      elsif v.class == Array
        new_hash[k] = keys_to_symbol_array(v)
      elsif v.class == TrueClass || v.class == FalseClass
        new_hash[k] = v.class.inspect
      else
        raise ArgumentError, "Type not supported: #{v.class}"
      end
    end
    return new_hash
  end

  def keys_to_symbol_array(array)
    new_array = []
    array.each do |i|
      if i.class == Hash
        new_array << keys_to_symbol(i)
      elsif i.class == Array
        new_array << keys_to_symbol_array(i)
      else
        new_array << i
      end
    end
    return new_array
  end

  # def getsKey(title)
  #   return parsed[title]
  # end

  # def getsKeysFromArray(title, *desired_qualities) 
  #   message = ""
  #   @parsed[title].each { |group|
  #     group.each do |key, value| #FRAIL 
  #       if doIOutputAMessage?(key, value, *desired_qualities)
  #         message << formatsOneQuality(key, value) 
  #       end
  #     end
  #   }
  #   return message
  # end

  # def setupOneMessageBodySection(title, group, *desired_qualities)#, *desired_qualities)
  #   message = ""
    
  #   return message
  # end

  # def formatsOneQuality(key, value  )
  #   return "   #{key}: #{value}\n"
  # end

  # def doIOutputAMessage?(key, value, *desired_qualities)
  #     areThereDesiredQualities?(*desired_qualities) ? (validKey?(key, *desired_qualities) ? true : false ) : true
  # end

  # def areThereDesiredQualities?(*desired_qualities)
  #   desired_qualities != [] ? true : false
  # end

  # def validKey?(key, *desired_qualities)
  #   desired_qualities.each { |desired_key| 
  #     return true if desired_key == key }
  #   return false
  # end

  # def keys_to_symbol(h)
  #   new_hash = {}
  #   h.each do |k,v|
  #     if v.class == String || v.class == Fixnum || v.class == Float
  #       new_hash[k.to_sym] = v
  #     elsif v.class == Hash
  #       new_hash[k.to_sym] = keys_to_symbol(v)
  #     elsif v.class == Array
  #       new_hash[k.to_sym] = keys_to_symbol_array(v)
  #     else
  #       raise ArgumentError, "Type not supported: #{v.class}"
  #     end
  #   end
  #   return new_hash
  # end

  # def keys_to_symbol_array(array)
  #   new_array = []
  #   array.each do |i|
  #     if i.class == Hash
  #       new_array << keys_to_symbol(i)
  #     elsif i.class == Array
  #       new_array << keys_to_symbol_array(i)
  #     else
  #       new_array << i
  #     end
  #   end
  #   return new_array
  # end

end