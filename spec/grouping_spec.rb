require_relative '../lib/grouping.rb'

describe Grouping do
  before :each do
    @example_card = Grouping.new(JSON.parse(open("input/one_card_section.json").read))
    @cats_array_card = Grouping.new(JSON.parse('{"cats":[{ "name":"Muffin", "fur":"tawny", "claws":true },
      { "name":"Snowflake", "fur":"white", "claws":true} ]}'))
    @pets_single_hash = Grouping.new(JSON.parse('{"pets":{"dog":"Fido"}}'))
    @instruments_multi_hash_card = Grouping.new(JSON.parse('{"instruments":{"fiddle":"strings", "clarinet":"woodwind", "trumpet":"brass"}}'))
    @phone_object_card = Grouping.new(JSON.parse('{"phone":true}'))
    @cars_object_card = Grouping.new(JSON.parse('{"mine":{"sedan":true},"yours":{"sedan":false}}'))
    @blank_card = Grouping.new(JSON.parse('{}'))
  end

  describe "#returnsInformation" do 
    it "returns a message when given a valid title" do 
      @cats_array_card.returnsInformation("fur").index("associated").should_not be_nil
      @example_card.returnsInformation("cards", "name", "url").index("https://").should_not be_nil
      @example_card.returnsInformation("lists", "name").index("Waiting for").should_not be_nil
      @pets_single_hash.returnsInformation("pets").index("Fido").should_not be_nil
      @instruments_multi_hash_card.returnsInformation("instruments").index("strings").should_not be_nil
      @phone_object_card.returnsInformation("phone").index("phone").should_not be_nil
      @instruments_multi_hash_card.returnsInformation("instruments").index("instruments").should_not be_nil
      @instruments_multi_hash_card.returnsInformation("instruments").kind_of?(String).should be_true
      @instruments_multi_hash_card.returnsInformation("instruments").index("fiddle").should_not be_nil
      @instruments_multi_hash_card.returnsInformation("instruments", "fiddle").index("fiddle").should_not be_nil
      @instruments_multi_hash_card.returnsInformation("instruments", "fiddle").index("strings").should_not be_nil
      @instruments_multi_hash_card.returnsInformation("instruments").index("clarinet").should_not be_nil
      @instruments_multi_hash_card.returnsInformation("instruments").index("brass").should_not be_nil
      @cars_object_card.returnsInformation("yours").index("yours").should_not be_nil
      @cars_object_card.returnsInformation("yours").index("false").should_not be_nil
    end
    it "returns an explaination when given a bad title" do 
      @instruments_multi_hash_card.returnsInformation("foo").should_not be_nil
      @instruments_multi_hash_card.returnsInformation("foo").kind_of?(String).should be_true
      @instruments_multi_hash_card.returnsInformation("foo").index("associated").should_not be_nil
      @cats_array_card.returnsInformation("monkey").index("associated").should_not be_nil
      @blank_card.returnsInformation("boom").index("associated").should_not be_nil
    end
  end

  describe "#setupWholeMessage" do 
    it "returns the title" do 
      @instruments_multi_hash_card.setupWholeMessage("instruments", "fiddle").index("instruments").should_not be_nil
      @instruments_multi_hash_card.setupWholeMessage("instruments").index("instruments").should_not be_nil
    end
    it "returns a message body" do 
      @instruments_multi_hash_card.setupWholeMessage("instruments", "fiddle").index("fiddle").should_not be_nil
      @instruments_multi_hash_card.setupWholeMessage("instruments", "fiddle").index("strings").should_not be_nil
      @instruments_multi_hash_card.setupWholeMessage("instruments").index("clarinet").should_not be_nil
      @instruments_multi_hash_card.setupWholeMessage("instruments").index("brass").should_not be_nil
    end
  end

  describe "#returnsMessageBody" do 
    it "accepts for 'title' to have an array" do 
      @cats_array_card.returnsMessageBody("cats").should_not be_nil
      @cats_array_card.returnsMessageBody("cats").kind_of?(String).should be_true
      @cats_array_card.returnsMessageBody("cats").index("Muffin").should_not be_nil
      @cats_array_card.returnsMessageBody("cats").index("Snowflake").should_not be_nil
      @cats_array_card.returnsMessageBody("cats", "fur").index("tawny").should_not be_nil
    end
    it "accepts for 'title' to have an object/hash" do 
      @pets_single_hash.returnsMessageBody("pets").should_not be_nil
      @pets_single_hash.returnsMessageBody("pets").kind_of?(String).should be_true
      @pets_single_hash.returnsMessageBody("pets").index("Fido").should_not be_nil
    end
  end

  describe "#loopInArrayToSetupMessageBody" do 
    it "needs a test" do 
    end 
  end

  describe "#setupMessageBody" do 
    it "needs a test" do 
    end 
  end

  describe "#setupOneMessageBodySection" do 
    it "needs a test" do 
    end 
  end

  describe "#doIOutputAMessage?" do 
    it "is false if there is null value" do 
      @blank_card.doIOutputAMessage?("color", "").should be_false
    end
    it "is false if desired key is invalid" do 
      @blank_card.doIOutputAMessage?("color", "", "hummingbirds", "owls", "hawks").should be_false
    end
    it "is true if a value is not empty" do 
      @blank_card.doIOutputAMessage?("color", "red").should be_true
    end
    it "is true if value is not empty and desired key is a valid key" do 
      @blank_card.doIOutputAMessage?("color", "red", "color", "shape", "texture").should be_true
    end
  end

  describe "#areThereDesiredQualities?" do 
    it "checks if there are passed desired qualities to look through" do 
      @blank_card.areThereDesiredQualities?().should be_false
      @blank_card.areThereDesiredQualities?("book").should be_true
      @blank_card.areThereDesiredQualities?("postcard", "poster", "pencil").should be_true
    end
  end

  describe "#validKey?" do 
    it "checks if key to a given set of desired qualities is valid" do 
      @blank_card.validKey?("pencil", "hat", "scarf", "cap").should be_false
      @blank_card.validKey?("pencil", "pen", "pencil", "quill", "marker").should be_true
    end
  end

  describe "#failedTitleMessage" do 
    it "returns failed message" do 
      @instruments_multi_hash_card.returnsInformation("foo").should_not be_nil
      @instruments_multi_hash_card.returnsInformation("foo").kind_of?(String).should be_true
      @instruments_multi_hash_card.returnsInformation("foo").index("associated").should_not be_nil
    end 
  end

  describe "#validTitle?" do 
    it "is true if the title is a quality in the json file" do
      @example_card.validTitle?("labelNames").should be_true
      @instruments_multi_hash_card.validTitle?("instruments").should be_true
    end

    it "is false if the title is a not quality in the json file" do
      @example_card.validTitle?("foo").should be_false
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

  describe "#formatsOneKeyValuePair" do 
    it "needs a test" do 
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

  describe "#isAKeyValuePair?" do 
    it "is a key-value pair" do 
      @phone_object_card.isAKeyValuePair?(@phone_object_card.parsed).should be_true
      @pets_single_hash.isAKeyValuePair?(@pets_single_hash.parsed["pets"]).should be_true
    end
    it "is not a key-value pair" do 
      @pets_single_hash.isAKeyValuePair?(@pets_single_hash.parsed).should be_false
    end
  end

end