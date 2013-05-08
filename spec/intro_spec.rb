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
    it "follows a given desired path: Follow cats -> name and return Muffin and Snowflake" do 
      intro = Intro.new(["cats", "name"])
      intro.sort(@multi_cats)  
      path_terminations = intro.full_paths.map { |single_path| 
        single_path.last}.to_s
      puts path_terminations
    end
  end

end
