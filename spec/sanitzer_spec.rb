require_relative "./spec_helper"

describe Cocaine::Sanitizer do

  let(:sanitizer) { Cocaine::Sanitizer.new }

  context "attr_accessor" do
    it "responds to 'removed_strings'" do
      expect(sanitizer).to respond_to :removed_strings
      expect(sanitizer).to respond_to :removed_strings=
    end
  end

  describe "#initialize" do
    it "sets removed_strings to be an empty array" do
      expect(sanitizer.removed_strings).to eq([])
    end
  end

  describe "#replace_escaped_quotes" do
    it "replaces all escaped single quote marks with unlikely string" do
      string = %|some.code('words \\'go here\\' sir') \n 'Here\\'s'.more_code|
      result = sanitizer.replace_escaped_quotes(string)
      expected = %|some.code('words COCAINE_SINGLE_QUOTE_STRgo hereCOCAINE_SINGLE_QUOTE_STR sir') \n 'HereCOCAINE_SINGLE_QUOTE_STRs'.more_code|
      expect(result).to eq(expected)
    end

    it "replaces all escaped double quote marks with unlikely string" do
      string = %|some.code("words \\"go here\\" sir") \n "Here\\'s".more_code|
      result = sanitizer.replace_escaped_quotes(string)
      expected = %|some.code("words COCAINE_DOUBLE_QUOTE_STRgo hereCOCAINE_DOUBLE_QUOTE_STR sir") \n "HereCOCAINE_SINGLE_QUOTE_STRs".more_code|
      expect(result).to eq(expected)
    end

    it "doesn't change the original string" do
      original_string = %|some.code("words \\"go here\\" sir") \n "Here\\'s".more_code|
      string_clone = original_string.clone
      sanitizer.replace_escaped_quotes(original_string)
      expect(original_string).to eq(string_clone)
    end
  end

  describe "#replace_string_literals" do

    context "when replacing single quote literals" do
      xit "replaces string literals with unlikely string and index" do
        string = %| chunk.of('code is there')|
        result = sanitizer.replace_string_literals(string)
        expected = %| chunk.of(COCAINE_SINGLE_STRING_coke0)|
        expect(result).to eq(expected)
      end


    end

    context "when replacing double quote literals" do
      xit "replaces single quote string literals with unlikely string and index" do
        string = %| chunk.of("code is there")|
        result = sanitizer.replace_string_literals(string)
        expected = %| chunk.of(COCAINE_DOUBLE_STRING_coke0)|
        expect(result).to eq(expected)
      end


    end
  end
end

