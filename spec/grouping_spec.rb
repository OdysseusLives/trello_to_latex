require_relative '../lib/grouping.rb'

describe Grouping do
  before :each do
    @example_card = Grouping.new(JSON.parse(open("input/one_card_section.json").read))
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

  describe "#formatsOneGroup" do 
    it "returns a string when given a valid title" do 
      @example_card.formatsOneGroup("labelNames").kind_of?(String).should be_true
    end

    it "returns a string when given a bad title" do 
      @example_card.formatsOneGroup("foo").kind_of?(String).should be_true
    end

    it "returns an explaination when given a bad title" do 
      @example_card.formatsOneGroup("foo").index("associated").should_not be_nil
    end
  end

  describe "#groupIsHidingInAnArray?" do 
    it "determines if a group has an array as a 'key' in a hash" do
      @example_card.groupIsHidingInAnArray?("cards").should be_true
    end
  end
end