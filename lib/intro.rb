require "rubygems"
require "json"

class Intro
  def keys_to_symbol(h, *step)
    new_hash = {}
    wanted = ""
    h.each do |k,v|
      # if steps != []
      #   steps.each { |step| 
      #     puts "step #{step} k #{k} v #{v}"
      #     new_hash[k] = keys_to_symbol_logic(h, k, v, *step) if k == step 
      #   }
      #   new_hash["bar"] = "boo"
      # else
        # new_hash[k] = keys_to_symbol_logic(h, k, v, *step)
        wanted << keys_to_symbol_logic(h, k, v, *step)
      # end
    end
    # return new_hash
    return wanted
  end

  def keys_to_symbol_logic(h, k, v, *step)
    # new_hash = {}
    wanted = ""
    puts "step #{step[0]} k #{k} v #{v}"
    if v.class == String || v.class == Fixnum || v.class == Float
      # new_hash[k] = v if k == step[0]
      wanted << "#{k}: #{v}" if k == step[0]
      puts "#{k}: #{v}" if k == step[0]
    elsif v.class == Hash
      # new_hash[k] = keys_to_symbol(v, *step)
      wanted = keys_to_symbol(v, *step)
    elsif v.class == Array
      # new_hash[k] = keys_to_symbol_array(v, *step)
      wanted = keys_to_symbol(v, *step)
    elsif v.class == TrueClass || v.class == FalseClass
      puts "eep #{k} #{v}" if k == step[0] 
      wanted << "#{k}: #{v}" if k == step[0]
      # new_hash[k] = v.class.inspect if k == step[0]
    else
      raise ArgumentError, "Type not supported: #{v.class}"
    end
    return wanted
  end

  def keys_to_symbol_array(array, *step)
    new_array = []
    array.each do |i|
      if i.class == Hash
        new_array << keys_to_symbol(i, *step)
      elsif i.class == Array
        new_array << keys_to_symbol_array(i, *step)
      else
        new_array << i
      end
    end
    return new_array
  end

end