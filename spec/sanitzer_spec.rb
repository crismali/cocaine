require_relative "./spec_helper"

describe Cocaine::Sanitizer do

  let(:sanitizer) { Cocaine::Sanitizer.new }
  let(:temp_single_quote_char) { Cocaine::Sanitizer::SINGLE_REPLACEMENT_CHAR }
  let(:temp_double_quote_char) { Cocaine::Sanitizer::DOUBLE_REPLACEMENT_CHAR }
  let(:temp_single_quote) { Cocaine::Sanitizer::SINGLE_REPLACEMENT_STRING }
  let(:temp_double_quote) { Cocaine::Sanitizer::DOUBLE_REPLACEMENT_STRING }

  context "attr_accessor" do
    it "responds to 'removed_single_quote_strings'" do
      expect(sanitizer).to respond_to :removed_single_quote_strings
      expect(sanitizer).to respond_to :removed_single_quote_strings=
    end

    it "responds to 'removed_double_quote_strings'" do
      expect(sanitizer).to respond_to :removed_double_quote_strings
      expect(sanitizer).to respond_to :removed_double_quote_strings=
    end
  end

  describe "#initialize" do
    it "sets removed_double_quote_strings to be an empty array" do
      expect(sanitizer.removed_double_quote_strings).to eq([])
    end

    it "sets removed_single_quote_strings to be an empty array" do
      expect(sanitizer.removed_single_quote_strings).to eq([])
    end
  end

  describe "#replace_escaped_quotes" do
    it "replaces all escaped single quote marks with unlikely string" do
      string = %|some.code('words \\'go here\\' sir') \n 'Here\\'s'.more_code|
      result = sanitizer.replace_escaped_quotes(string)
      expected = %|some.code('words #{temp_single_quote_char}go here#{temp_single_quote_char} sir') \n 'Here#{temp_single_quote_char}s'.more_code|
      expect(result).to eq(expected)
    end

    it "replaces all escaped double quote marks with unlikely string" do
      string = %|some.code("words \\"go here\\" sir") \n "Here\\'s".more_code|
      result = sanitizer.replace_escaped_quotes(string)
      expected = %|some.code("words #{temp_double_quote_char}go here#{temp_double_quote_char} sir") \n "Here#{temp_single_quote_char}s".more_code|
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

    it "doesn't change the original string" do
      original_string = %|some.code("words go here sir")|
      string_clone = original_string.clone
      sanitizer.replace_string_literals(original_string)
      expect(original_string).to eq(string_clone)
    end

    context "when replacing single quote literals" do

      let(:first_string_literal) { %|'code is there'| }
      let(:second_string_literal) { %|'and strings are here'| }
      let(:string) { %| chunk.of(#{first_string_literal}, #{second_string_literal})| }

      let!(:result) { sanitizer.replace_string_literals(string) }

      it "replaces string literals with unlikely string and index" do
        expected = %| chunk.of(#{temp_single_quote}0, #{temp_single_quote}1)|
        expect(result).to eq(expected)
      end

      it "adds the extracted strings to the single quote strings array" do
        expect(sanitizer.removed_single_quote_strings).to include first_string_literal
        expect(sanitizer.removed_single_quote_strings).to include second_string_literal
      end

      it "ensures that each string added to the arrays is at the proper index" do
        removed_strings = sanitizer.removed_single_quote_strings
        expect(removed_strings.first).to eq(first_string_literal)
        expect(removed_strings.last).to eq(second_string_literal)
      end

      it "ensures that each temp string has the right index attached to it" do
        expect(result).to match(/#{temp_single_quote}0/)
        expect(result).to match(/#{temp_single_quote}1/)
      end
    end

    context "when replacing double quote literals" do
      let(:first_string_literal) { %|"code is there"| }
      let(:second_string_literal) { %|"and strings are here"| }
      let(:string) { %| chunk.of(#{first_string_literal}, #{second_string_literal})| }

      let!(:result) { sanitizer.replace_string_literals(string) }

      it "replaces string literals with unlikely string and index" do
        expected = %| chunk.of(#{temp_double_quote}0, #{temp_double_quote}1)|
        expect(result).to eq(expected)
      end

      it "adds the extracted strings to the double quote strings array" do
        expect(sanitizer.removed_double_quote_strings).to include first_string_literal
        expect(sanitizer.removed_double_quote_strings).to include second_string_literal
      end

      it "ensures that each string added to the arrays is at the proper index" do
        removed_strings = sanitizer.removed_double_quote_strings
        expect(removed_strings.first).to eq(first_string_literal)
        expect(removed_strings.last).to eq(second_string_literal)
      end

      it "ensures that each temp string has the right index attached to it" do
        expect(result).to match(/#{temp_double_quote}0/)
        expect(result).to match(/#{temp_double_quote}1/)
      end
    end

    context "when replacing double and single quote strings" do
      let(:first_string_literal) { %|"code is there"| }
      let(:second_string_literal) { %|'and strings are here'| }
      let(:string) { %| chunk.of(#{first_string_literal}, #{second_string_literal})| }

      let!(:result) { sanitizer.replace_string_literals(string) }

      it "replaces string literals with unlikely string and index" do
        expected = %| chunk.of(#{temp_double_quote}0, #{temp_single_quote}0)|
        expect(result).to eq(expected)
      end

      it "adds the extracted strings to the double quote strings array" do
        expect(sanitizer.removed_double_quote_strings).to include first_string_literal
        expect(sanitizer.removed_single_quote_strings).to include second_string_literal
      end

      it "ensures that each temp string has the right index attached to it" do
        expect(result).to match(/#{temp_double_quote}0/)
        expect(result).to match(/#{temp_single_quote}0/)
      end
    end
  end

  describe "#sanitize" do

    let(:complex_string) do
      %| Some.new("code")
        with('lots of', 'strings\\'n', "such")
        "there are also \\n
        multi-line strings with random \\"escaped quotes \\" "
       |
    end

    let!(:result) { sanitizer.sanitize(complex_string) }

    it "replaces escaped quotes" do
      removed_double_quote_strings = sanitizer.removed_double_quote_strings
      removed_single_quote_strings = sanitizer.removed_single_quote_strings

      expect(removed_single_quote_strings.any?{ |s| s.match(temp_single_quote_char)})
        .to be_true
      expect(removed_double_quote_strings.any?{ |s| s.match(temp_double_quote_char)})
        .to be_true
    end

    it "replaces both types of string literal" do
      expect(result).to match(temp_single_quote + 0.to_s)
      expect(result).to match(temp_double_quote + 0.to_s)
      expect(result).to match(temp_double_quote + 1.to_s)
    end

    it "returns text that doesn't contain escaped quotes or string literals" do
      expect(result).to_not match(temp_single_quote_char)
      expect(result).to_not match(temp_double_quote_char)

      expect(result).to_not match(Cocaine::Patterns::SINGLE_QUOTES_STRING)
      expect(result).to_not match(Cocaine::Patterns::DOUBLE_QUOTES_STRING)
    end
  end
end

