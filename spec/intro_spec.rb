require_relative '../lib/intro.rb'

describe Intro do
  before :each do
    @intro = Intro.new
    @dog = JSON.parse('{"name":"Spot"}')
    @pet_list = JSON.parse('{"pets":{"dog":"Fido"}}')
    @cat = JSON.parse('{"cat":[{ "name":"Peach", "fur":"short", "claws":true }]}')
    @multi_cats = JSON.parse('{"cats":[{ "name":"Muffin", "fur":"tawny", "claws":true },
      { "name":"Snowflake", "fur":"white", "claws":true} ]}')
    @user = JSON.parse('{"user": { "name": "foo", "age": 40, "location": { "city" : "bar", "state": "ca" } } }')
    @colors = JSON.parse('{"colors":["red", "green", "blue", "yellow"]}')
  end

  describe "#sort" do 
    it "tracks the path to a key when there is a straight path: pets -> dog -> Fido" do 
      @intro.sort(@pet_list)
      paths = @intro.full_paths.to_s
      paths.include?("pets").should be_true
      paths.include?("dog").should be_true
      paths.include?("Fido").should be_true
    end

    it "takes a single-array; full_paths returns a path to each terminal value" do 
      @intro.sort(@cat)
      paths = @intro.full_paths.to_s
      paths.should eq('[["cat", "name", "Peach"], ["cat", "fur", "short"], ["cat", "claws", true]]')
    end

    it "takes a multiple-array; full_paths returns a path to each terminal value" do 
      @intro.sort(@multi_cats)
      paths = @intro.full_paths.to_s
      paths.should eq('[["cats", "name", "Muffin"], ["cats", "fur", "tawny"], ["cats", "claws", true], ["cats", "name", "Snowflake"], ["cats", "fur", "white"], ["cats", "claws", true]]')
    end

    it "takes an object; full_paths returns a path to each terminal value" do 
      @intro.sort(@dog)
      paths = @intro.full_paths.to_s
      paths.should eq('[["name", "Spot"]]')
    end

    it "takes a hash; full_paths returns a path to each terminal value" do 
      @intro.sort(@pet_list)
      paths = @intro.full_paths.to_s
      paths.should eq('[["pets", "dog", "Fido"]]')
    end

    it "takes an array that doesn't hold a hash; full_paths returns a path to each terminal value" do 
      @intro.sort(@colors)
      paths = @intro.full_paths.to_s
      paths.should eq('[["colors", "red"], ["colors", "green"], ["colors", "blue"], ["colors", "yellow"]]')
    end

    it "follows a given desired path: Follow cats -> name and return Muffin and Snowflake" do 
      intro = Intro.new(["cats", "name"])
      intro.sort(@multi_cats)
      path_terminations = intro.path_terminations.to_s
      path_terminations.should eq('["Muffin", "Snowflake"]')
    end
  end

  describe "#is_a_flat_array" do 
    it "when given index[0] of a string, understands this string is a terminal piece of data" do 
      @intro.is_a_flat_array("string").should be_true
    end

    it "when given a hash, understands this is not a terminal piece of data" do 
      poster = JSON.parse('{"black&white":"true"}')
      @intro.is_a_flat_array(poster).should be_false
    end
  end

  describe "#add_to_full_paths" do 
    it "adds an array value to an empty array" do 
      numbers = ["one", "two", "three"]
      number_path = @intro.add_to_full_paths(numbers)
      number_path.should eq([numbers])
    end

    it "adds an array value to an array" do 
      numbers123 = ["one", "two", "three"]
      @intro.add_to_full_paths(numbers123)
      numbers456 = ["four", "five", "six"]
      number_path = @intro.add_to_full_paths(numbers456)
      number_path.should eq([numbers123, numbers456])
    end
  end

  describe "#create_path_terminations" do 
    it "returns the last value of an array, which is the value of a path" do 
      binder_dimensions = [["binder", "height", "11in"], ["binder", "width", "8in"], ["binder", "depth", "1.5in"]]
      dimensions = ["11in", "8in", "1.5in"].to_s
      terminations = @intro.create_path_terminations(binder_dimensions).to_s
      terminations.should eq(dimensions)
    end
  end

end
