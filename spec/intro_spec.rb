require_relative '../lib/intro.rb'

describe Intro do
  before :each do
    @intro = Intro.new
    @dog = JSON.parse('{"name":"Spot"}')
    @dogs = JSON.parse('{"pets":{"dog":"Fido"}}')
    @cat = JSON.parse('{"cat":[{ "name":"Peach", "fur":"short", "claws":true }]}')
    @cats = JSON.parse('{"cats":[{ "name":"Muffin", "fur":"tawny", "claws":true },
      { "name":"Snowflake", "fur":"white", "claws":true} ]}')
    @user = JSON.parse('{"user": { "name": "foo", "age": 40, "location": { "city" : "bar", "state": "ca" } } }')
  end

  describe "#keys_to_symbol" do 
    # it "accepts an object" do 
    #   puts @intro.keys_to_symbol(@dog)
    #   @intro.keys_to_symbol(@dog).to_s.include?("Spot").should be_true
    # end
    # it "accepts a single-array" do 
    #   puts @intro.keys_to_symbol(@cat)
    #   @intro.keys_to_symbol(@cat).to_s.include?("Peach").should be_true
    # end
    # it "accepts a multiple-array" do 
    #   puts @intro.keys_to_symbol(@cats)
    #   @intro.keys_to_symbol(@cats).to_s.include?("Snowflake").should be_true
    # end
    # it "accepts a hash" do 
    #   puts @intro.keys_to_symbol(@dogs)
    #   @intro.keys_to_symbol(@dogs).to_s.include?("Fido").should be_true
    # end
    # it "allows for lots of recursion" do 
    #   puts @intro.keys_to_symbol(@user)
    #   @intro.keys_to_symbol(@user).to_s.include?("state").should be_true
    # end
    it "returns only the name of a cat" do 
      @intro.keys_to_symbol(@cat, "name").should eq("5")
    end
  end

  # describe "#keys_to_symbol_array" do 
  # end

end
