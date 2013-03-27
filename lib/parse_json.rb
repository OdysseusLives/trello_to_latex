require "rubygems"
require "json"

string = '{"desc":{"someKey":"someValue","anotherKey":"value"},"main_item":{"stats":{"a":8,"b":12,"c":10}}}'
parsed = JSON.parse(string) # returns a hash

p parsed["desc"]["someKey"]
p parsed["main_item"]["stats"]["a"]

# Read JSON from a file, iterate over objects
file = open("input/one_card_section.json")
json = file.read

parsed = JSON.parse(json)
@tags = JSON.parse( json )[ "cards" ]
@tags.each do |item| 
  puts "All items: #{item}"
  puts "Only the id: #{item["id"]}"
end