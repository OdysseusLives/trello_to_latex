require_relative '../lib/grouping.rb'

describe Grouping do
  before :each do
    @example_card = Grouping.new(JSON.parse(open("input/one_card_section.json").read))
    @cats_array_card = Grouping.new(JSON.parse('{"cats":[{ "name":"Muffin", "fur":"tawny", "claws":true },
      { "name":"Snowflake", "fur":"white", "claws":true} ]}'))
    @dogs = JSON.parse('{"pets":{"dog":"Fido"}}')
    @pets_single_hash = Grouping.new(@dogs)
    @instruments_multi_hash_card = Grouping.new(JSON.parse('{"instruments":{"fiddle":"strings", "clarinet":"woodwind", "trumpet":"brass"}}'))
    @phone_object_card = Grouping.new(JSON.parse('{"phone":true}'))
    @cars = JSON.parse('{"mine":{"sedan":true},"yours":{"sedan":false}}')
    @cars_object_card = Grouping.new(@cars)
    @blank_card = Grouping.new(JSON.parse('{}'))
    @school_classes_card = Grouping.new(JSON.parse('{"history":{"US":true, "World":true, "Ancient":true}, 
      "math":{"Algebra":true, "Geometry":true, "Calculus":true}, 
      "language":"French", 
      "English":{"Language":true, "Literature":true}, 
      "science":{"Biology":true, "Chemistry":true, "Physics":true}}'))
    @bird = JSON.parse('{"name":"birdie", "bird":"native species", "type":"bird", "color":{"tail":"red", "wings":"striped", "body":"black"},
      "id":"id12345","notes":"his height is 4.5cm and weight is 1oz","height":"6inches","weight":"1/2 lb"}')
    @bird_card = Grouping.new(@bird)
  end

  describe "#returnsInformationUsingConfig(line)" do 
    it "takes an array" do 
      @blank_card.returnsInformationUsingConfig(["foo"]).should_not be_nil
      @cars_object_card.returnsInformationUsingConfig(["mine"]).should_not be_nil
    end
    it "parses a title and *desired_qualities from the array" do 
      @cats_array_card.returnsInformationUsingConfig(["cats", "name", "fur"])
      @cats_array_card.title.should eq("cats")
    end
    it "returns the message from returnsInformation" do 
      @cats_array_card.returnsInformationUsingConfig(["cats", "name", "fur"]).index("Muffin").should_not be_nil
    end
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
    it "calls loopInArrayToSetupMessageBody if title refers to an array" do
      @cats_array_card.loopInArrayToSetupMessageBody("cats", "fur").index("tawny").should_not be_nil
    end
    it "calls setupMessageBody if title refers to a object/hash" do 
      @pets_single_hash.returnsMessageBody("pets").should_not be_nil
      @pets_single_hash.returnsMessageBody("pets").kind_of?(String).should be_true
      @pets_single_hash.returnsMessageBody("pets").index("Fido").should_not be_nil
    end
  end

  describe "#loopInArrayToSetupMessageBody" do 
    it "takes each 'value' for the main key and loops to create the message body - used for arrays" do 
      @cats_array_card.loopInArrayToSetupMessageBody("cats").should_not be_nil
      @cats_array_card.loopInArrayToSetupMessageBody("cats").kind_of?(String).should be_true
      @cats_array_card.loopInArrayToSetupMessageBody("cats").index("Muffin").should_not be_nil
      @cats_array_card.loopInArrayToSetupMessageBody("cats").index("Snowflake").should_not be_nil
      @cats_array_card.loopInArrayToSetupMessageBody("cats", "fur").index("tawny").should_not be_nil
    end 
  end

  describe "#setupMessageBody" do 
    it "catches key-value pairs and returns message" do 
    end 
    it "catches non-key-value pairs and returns message" do
    end
  end

  describe "#setupOneMessageBodySection" do 
    it "does not output a message if doIOutputAMessage is false" do 
    end 
    it "creates all messages for the bdy section for all that make doIOutputAMessage evaluate to true" do 
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
      @instruments_multi_hash_card.failedTitleMessage("foo").should_not be_nil
      @instruments_multi_hash_card.failedTitleMessage("foo").kind_of?(String).should be_true
      @instruments_multi_hash_card.failedTitleMessage("foo").index("associated").should_not be_nil
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
    it "has title in the message" do 
      @phone_object_card.formatsOneKeyValuePair("phone").index("phone").should_not be_nil
    end 
    it "has the value in the message" do 
      @phone_object_card.formatsOneKeyValuePair("phone").index("true").should_not be_nil
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
      @phone_object_card.isAHash?("phone").should be_false 
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
      @phone_object_card.isAKeyValuePair?("phone").should be_true
      @school_classes_card.isAKeyValuePair?("language").should be_true
      @school_classes_card.isAKeyValuePair?("Physics").should be_true
    end
    it "is not a key-value pair" do 
      @pets_single_hash.isAKeyValuePair?("pets").should be_false
    end
  end

  describe "searchForFeature" do 
    it "returns array of indecies of end points based on where features are found" do 
      title = "sedan"
      container = @cars.to_s
      start_point = @cars_object_card.startPointAfterTitle(title, container, 0)
      features = ["=>", ",", "{"]
      end_points = []
      end_points[0] = container.length
      counter = 1
      @cars_object_card.searchForFeature(title, container, start_point, features, end_points, counter).should eq([52, 32, 23, 23]) 
    end
  end

  describe "#hasNoWords?" do 
    it "looks for words with a regex" do 
      title = "sedan"
      container = @cars.to_s
      start_point = @cars_object_card.startPointAfterTitle(title, container, 0)
      end_points = [52, 32, 23, 23]
      @cars_object_card.hasNoWords?(container, start_point, end_points).should be_false
    end
    it "looks for words with a regex, part2" do 
      title = "pets"
      container = JSON.parse('{"pets":{"dog":"Fido"}}').to_s
      start_point = @blank_card.startPointAfterTitle(title, container, 0)
      features = ["=>", ",", "{"]
      end_points = []
      end_points[0] = container.length
      counter = 1
      end_points = @blank_card.searchForFeature(title, container, start_point, features, end_points, counter)
      @blank_card.hasNoWords?(container, start_point, end_points).should be_true
    end

  end

  describe "#hasAFeature?" do
    it "determines if there is an arrow in the given string" do 
      container = @cars.to_s
      @blank_card.hasAFeature?(container, 0, container.length, "=>").should be_true
      @blank_card.hasAFeature?(container, container.length - 2, container.length, "=>").should be_false
      @blank_card.hasAFeature?(container, 0, container.length, ",").should be_true
      @blank_card.hasAFeature?(container, container.length - 2, container.length, ",").should be_false
    end
  end

  describe "#hereIsThisFeature" do
    it "determines if there is an arrow in the given string" do 
      container = @cars.to_s
      @blank_card.hereIsThisFeature(container, 0, container.length, "=>").should eq(6)
      @blank_card.hereIsThisFeature(container, container.length - 2, container.length, "=>").should be_nil
      @blank_card.hereIsThisFeature(container, 0, container.length, ",").should eq(23)
      @blank_card.hereIsThisFeature(container, container.length - 2, container.length, ",").should be_nil
    end
  end

  describe "#startPointAfterTitle" do
     it "returns an string index location of where the 'title' has been found + its length + length of '\" ,'" do  
      container = @cars.to_s
      @cars_object_card.startPointAfterTitle("mine", container, 0).should eq(9)
    end
    it "knows what 'title' I'm looking for" do 
      # For reference: @bird: {"name"=>"birdie", "bird"=>"native species", "type"=>"bird", "color"=>{"tail"=>"
      # red", "wings"=>"striped", "body"=>"black"}, "id"=>"id12345", "notes"=>"his heigh
      # t is 4.5cm and weight is 1oz", "height"=>"6inches", "weight"=>"1/2 lb"}
      @bird_card.startPointAfterTitle("bird", @bird.to_s, 0).should eq(27)
      @bird_card.startPointAfterTitle("bird", @bird.to_s, 0).should_not eq(17)
      numbers = JSON.parse('{"2":"7","1":"6","0":"4","8":"2","6":"0"}') # Counted out so each num is the singles-digit
      numbers_card = Grouping.new(numbers)
      numbers_card.startPointAfterTitle("6", numbers.to_s, 0).should eq(46) # And not eq(that first 6)
    end
  end

  describe "#findTitle" do
    it "returns an integer when given a title and a string container" do 
      @cars_object_card.findTitle("mine", @cars.to_s, 0).kind_of?(Integer).should be_true
    end
    it "returns an string index location of where the 'title' has been found" do 
      @cars_object_card.findTitle("mine", @cars.to_s, 0).should eq(2)
      @pets_single_hash.findTitle("dog", @dogs.to_s, 0).should eq(11)
      @bird_card.findTitle("bird", @bird.to_s, 0).should eq(10)
      @cars_object_card.findTitle("mine", @cars.to_s, 0).should eq(2)
    end
  end

  describe "#isTitleATitleAndNotAnAttribute?" do 
    it "determines if the first instance of the string of 'title' is in fact the one I want" do 
      title = "bird"
      container = @bird.to_s
      @bird_card.isTitleATitleAndNotAnAttribute?(title, container, 10).should be_false
      container.index("bird").should eq(10)
      @bird_card.isTitleATitleAndNotAnAttribute?(title, container, 20).should be_true
      container.index("bird", 20).should eq(20)
      @bird_card.isTitleATitleAndNotAnAttribute?(title, container, 54).should be_false
      container.index("bird", 54).should eq(54)
      @cars_object_card.isTitleATitleAndNotAnAttribute?("mine", @cars.to_s, 2).should be_true
    end 
  end

  describe "#updateEndPoint" do 
    it "looks for given features, returns old endpoint" do 
      container = @cars.to_s
      @cars_object_card.updateEndPoint(container, container.length - 2, container.length, "=>").should eq(container.length)
      @cars_object_card.updateEndPoint(container, container.length - 2, container.length, ",").should eq(container.length)
      @cars_object_card.updateEndPoint(container, 0, container.length, "=>").should eq(6)
    end
  end

end