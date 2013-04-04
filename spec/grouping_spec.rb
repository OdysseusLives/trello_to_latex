require_relative '../lib/grouping.rb'

describe Grouping do
  before :each do
    @example_card = Grouping.new(JSON.parse(open("input/one_card_section.json").read))
    @cats_array_card = Grouping.new(JSON.parse('{"cats":[{ "name":"Muffin", "fur":"tawny", "claws":true },
      { "name":"Snowflake", "fur":"white", "claws":true} ]}'))
    @pets_single_hash = Grouping.new(JSON.parse('{"pets":{"dog":"Fido"}}'))
    @instruments_multi_hash_card = Grouping.new(JSON.parse('{"instruments":{"fiddle":"strings", "clarinet":"woodwind", "trumpet":"brass"}}'))
    @phone_object_card = Grouping.new(JSON.parse('{"phone":true}'))
  end

  describe "#returnsInformation" do 
    it "gives data if title is valid" do 
      @cats_array_card.returnsInformation("fur").index("associated").should_not be_nil
      @example_card.returnsInformation("cards", "name", "url").index("https://").should_not be_nil
      @example_card.returnsInformation("lists", "name").index("Waiting for").should_not be_nil
    end
    it "gives 'failure' message if title is invalid" do 
      @cats_array_card.returnsInformation("monkey").index("associated").should_not be_nil
    end 
  end

  describe "#isAnArray?" do 
    it "is not an array" do 
      @example_card.isAnArray?("name").should be_false
      @example_card.isAnArray?("labelNames").should be_false
      @cats_array_card.isAnArray?("cats[0]").should be_false
      @pets_single_hash.isAnArray?("pets").should be_false
      @instruments_multi_hash_card.isAnArray?("instruments").should be_false
      @phone_object_card.isAnArray?("phone").should be_false
    end
    it "is an array" do 
      @example_card.isAnArray?("cards").should be_true
      @cats_array_card.isAnArray?("cats").should be_true
    end  
  end

  describe "#isAKeyValuePair?" do 
    it "is a key-value pair" do 
      @phone_object_card.isAKeyValuePair?(@phone_object_card.parsed).should be_true
      @pets_single_hash.isAKeyValuePair?(@pets_single_hash.parsed["pets"]).should be_true
    end
    it "is not a key-value pair" do 
      @pets_single_hash.isAKeyValuePair?(@pets_single_hash.parsed).should be_false
    end
  end

    describe "#isAnObject?" do 
    it "is not an object" do 
      @example_card.isAnObject?("labelNames").should be_false
      @example_card.isAnObject?("cards").should be_false
      @cats_array_card.isAnObject?("cats").should be_false
      @pets_single_hash.isAnObject?("pets").should be_false
      @instruments_multi_hash_card.isAnObject?("instruments").should be_false
    end
    it "is an object" do 
      @example_card.isAnObject?("name").should be_true
      @phone_object_card.isAnObject?("phone").should be_true
      @cats_array_card.isAnObject?("cats[0]").should be_true
    end
  end

  describe "#isAHash?" do 
    it "is not a hash" do 
      @example_card.isAHash?("name").should be_false
      @example_card.isAHash?("cards").should be_false
      @cats_array_card.isAHash?("cats").should be_false
      @cats_array_card.isAHash?("cats[0]").should be_false
      @phone_object_card.isAHash?("phone").should be_false #only key and value; not a hash iteself
    end
    it "is a hash" do 
      @example_card.isAHash?("labelNames").should be_true

      @pets_single_hash.isAHash?("pets").should be_true
      @pets_single_hash.parsed.each { |pet|
        @pets_single_hash.isAHash?(pet) }.should be_true
      
      @instruments_multi_hash_card.isAHash?("instruments").should be_true
      @instruments_multi_hash_card.parsed.each { |instrum| 
        @instruments_multi_hash_card.isAHash?(instrum) }.should be_true

      @cats_array_card.parsed.each { |cat| 
        cat.each { |traits|
          @cats_array_card.isAHash?(traits) } }.should be_true
    end   
  end

  describe "#formatsReferenceForColoredLabels" do
    it "returns a string" do 
      @example_card.formatsReferenceForColoredLabels.kind_of?(String).should eq(true)      
    end

    it "returns a string regarding a Reference" do 
      @example_card.formatsReferenceForColoredLabels.index("Reference").should_not eq(nil)
    end
  end

  describe "#formatsOneQuality" do 
    before :each do
      @value = "The Jungle"
      @message = @example_card.formatsOneQuality("book", @value, 2)
    end

    it "returns a string" do
      @message.kind_of?(String).should be_true
    end

    it "returns a string with the value inside"  do
      @message.index(@value).should_not be_nil
    end
  end

  describe "#validTitle?" do 
    it "is true if the title is a quality in the json file" do
      @example_card.validTitle?("labelNames").should be_true
    end

    it "is false if the title is a not quality in the json file" do
      @example_card.validTitle?("foo").should be_false
    end
  end

  describe "#setupWholeMessage" do 
    it "returns a string when given a valid title" do 
      @example_card.setupWholeMessage("labelNames").kind_of?(String).should be_true
    end

    it "returns a string when given a bad title" do 
      @example_card.setupWholeMessage("foo").kind_of?(String).should be_true
    end

    it "returns an explaination when given a bad title" do 
      @example_card.setupWholeMessage("foo").index("associated").should_not be_nil
    end
  end
end