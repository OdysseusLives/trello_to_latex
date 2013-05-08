require "rubygems"
require "json"

class Intro
  attr_reader :full_paths, :path_terminations
  def initialize(*desired_path)
    @full_paths = []
    @desired_path = desired_path
  end

  def sort(*path, given_data)
    new_hash = {}
    given_data.each do |key, value|
      if data_terminates_here(value) then 
          path << key 
          path << value
          path.flatten!
          add_to_full_paths(path)
          path.pop(2)
      elsif value.class == Hash then 
        path << key
        sort(path, value)
        path.pop
      elsif value.class == Array then 
        value.each { |array_value|
          path << key
          sort(path, array_value) 
          path.pop
        }
      else
        raise ArgumentError, "Type not supported: #{value.class}"
      end
    end
  end

  def data_terminates_here(value)
    true if value.class == String || value.class == Fixnum || 
      value.class == Float || value.class == TrueClass || 
      value.class == FalseClass || value.class == NilClass 
  end

  def add_to_full_paths(path)
    @full_paths << path.dup
    create_path_terminations(@full_paths)
  end

  def create_path_terminations(full_paths)
    @path_terminations = full_paths.map { |single_path| 
        single_path.last}.to_s
  end


end