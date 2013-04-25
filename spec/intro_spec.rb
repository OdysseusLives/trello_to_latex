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
    it "accepts an object" do 
      @intro.keys_to_symbol(@dog).to_s.include?("Spot").should be_true
    end
    it "accepts a single-array" do 
      @intro.keys_to_symbol(@cat).to_s.include?("Peach").should be_true
    end
    it "accepts a multiple-array" do 
      @intro.keys_to_symbol(@cats).to_s.include?("Snowflake").should be_true
    end
    it "accepts a hash" do 
      @intro.keys_to_symbol(@dogs).to_s.include?("Fido").should be_true
    end
    it "allows for lots of recursion" do 
      @intro.keys_to_symbol(@user).to_s.include?("state").should be_true
    end
  end

  # describe "#keys_to_symbol_array" do 
  # end


  # describe "#getsKey" do 
  #   it "returns the property value" do 
  #     @dog.getsKey("name").include?("Fido").should be_true
  #   end
  # end

  # describe "#getsKeysFromArray" do 
  #   before :each do
  #     @cats_name = @cats.getsKeysFromArray("cats", "name")
  #     puts "CATS: #{@cats_name}"
  #   end
  #   it "accepts an array with multiple values" do 
  #     @cats_name.kind_of?(String).should be_true
  #   end
  #   it "accepts an array with one value" do 
  #     @cat_name = @cat.getsKeysFromArray("cats", "name")
  #     @cat_name.kind_of?(String).should be_true
  #   end
  #   it "returns the values for key:'name'" do
  #     @cats_name.include?("Muffin").should be_true
  #     @cats_name.include?("Snowflake").should be_true
  #   end
  # end
end
