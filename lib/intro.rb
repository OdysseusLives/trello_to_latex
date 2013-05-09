require "rubygems"
require "json"

class Intro
  attr_reader :full_paths, :path_terminations
  def initialize(*desired_path)
    @full_paths = []
    @desired_path = (desired_path == [] ? desired_path : desired_path.flatten!)
  end

  def sort(*path, given_data)
    given_data.each do |key, value|
      if data_terminates_here(value) then 
          terminate_path(path, key, value)
      elsif value.class == Hash then 
        prepare_to_sort_again(path, key, value)
      elsif value.class == Array then 
        value.each { |array_value|
          prepare_to_sort_again(path, key, array_value)
        }
      else
        raise ArgumentError, "Type not supported: #{value.class}"
      end
    end
    create_path_terminations(@full_paths)
  end

  def prepare_to_sort_again(path, key, value)
    path << key
    array_is_flat = is_a_flat_array(value)
    if allow_path?(path) && !array_is_flat
      sort(path, value)
    elsif array_is_flat
      add_to_full_paths([key, value])
    end
    path.pop
  end

  def is_a_flat_array(value)
    return true if data_terminates_here(value[0])
    return false
  end

  def terminate_path(path, key, value)
    path << key 
    if allow_path?(path)
      path << value
      path.flatten!
      add_to_full_paths(path)
    end
    path.pop(2)
  end

  def allow_path?(path)
    path_index = path.length-1
    if @desired_path == [] then
        return true 
    else
        path.flatten!
        if path[0..path_index] == @desired_path[0..path_index] then 
          return true
        end
    end
    return false
  end

  def data_terminates_here(value)
    true if value.class == String || value.class == Fixnum || 
      value.class == Float || value.class == TrueClass || 
      value.class == FalseClass 
  end

  def add_to_full_paths(path)
    @full_paths << path.dup
  end

  def create_path_terminations(full_paths)
    @path_terminations = full_paths.map { |single_path| 
        single_path.last}.to_s
  end


end