require_relative "./spec_helper"

describe Cocaine::Sanitizer do

  let(:sanitizer) { Cocaine::Sanitizer.new }
  let(:temp_single_quote_char) { Cocaine::Sanitizer::SINGLE_REPLACEMENT_CHAR }
  let(:temp_double_quote_char) { Cocaine::Sanitizer::DOUBLE_REPLACEMENT_CHAR }
  let(:temp_single_quote) { Cocaine::Sanitizer::SINGLE_REPLACEMENT_STRING }
  let(:temp_double_quote) { Cocaine::Sanitizer::DOUBLE_REPLACEMENT_STRING }
  let(:temp_interpolated_js) { Cocaine::Sanitizer::INTERPOLATED_JS_REPLACEMENT_STRING }

  context "attr_accessor" do
    it "responds to 'removed_single_quote_strings'" do
      expect(sanitizer).to respond_to :removed_single_quote_strings
      expect(sanitizer).to respond_to :removed_single_quote_strings=
    end

    it "responds to 'removed_double_quote_strings'" do
      expect(sanitizer).to respond_to :removed_double_quote_strings
      expect(sanitizer).to respond_to :removed_double_quote_strings=
    end

    it "responds to 'removed_interpolated_js_strings'" do
      expect(sanitizer).to respond_to :removed_interpolated_js_strings
      expect(sanitizer).to respond_to :removed_interpolated_js_strings=
    end
  end

  describe "#initialize" do
    it "sets removed_double_quote_strings to be an empty array" do
      expect(sanitizer.removed_double_quote_strings).to eq([])
    end

    it "sets removed_single_quote_strings to be an empty array" do
      expect(sanitizer.removed_single_quote_strings).to eq([])
    end

    it "sets removed_interpolated_js_strings to be an empty array" do
      expect(sanitizer.removed_interpolated_js_strings).to eq([])
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

  describe "#replace_string_literals!" do

    it "doesn't change the original string" do
      original_string = %|some.code("words go here sir")|
      string_clone = original_string.clone
      sanitizer.replace_string_literals!(original_string)
      expect(original_string).to eq(string_clone)
    end

    context "when replacing single quote literals" do

      let(:first_string_literal) { %|'code is there'| }
      let(:second_string_literal) { %|'and strings are here'| }
      let(:string) { %| chunk.of(#{first_string_literal}, #{second_string_literal})| }

      let!(:result) { sanitizer.replace_string_literals!(string) }

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

      let!(:result) { sanitizer.replace_string_literals!(string) }

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

    context "when replacing interpolated javascript literals" do
      let(:first_interpolated_js) { %|`code is there`| }
      let(:second_interpolated_js) { %|`and js is here`| }
      let(:string) { %| chunk.of(#{first_interpolated_js}, #{second_interpolated_js})| }

      let!(:result) { sanitizer.replace_string_literals!(string) }

      it "replaces string literals with unlikely string and index" do
        expected = %| chunk.of(#{temp_interpolated_js}0, #{temp_interpolated_js}1)|
        expect(result).to eq(expected)
      end

      it "adds the extracted strings to the single quote strings array" do
        expect(sanitizer.removed_interpolated_js_strings).to include first_interpolated_js
        expect(sanitizer.removed_interpolated_js_strings).to include second_interpolated_js
      end

      it "ensures that each string added to the arrays is at the proper index" do
        removed_strings = sanitizer.removed_interpolated_js_strings
        expect(removed_strings.first).to eq(first_interpolated_js)
        expect(removed_strings.last).to eq(second_interpolated_js)
      end

      it "ensures that each temp string has the right index attached to it" do
        expect(result).to match(/#{temp_interpolated_js}0/)
        expect(result).to match(/#{temp_interpolated_js}1/)
      end
    end

    context "when replacing double quote, single quote, and interpolated js strings" do
      let(:first_string_literal) { %|"code is there"| }
      let(:second_string_literal) { %|'and strings are here'| }
      let(:third_string_literal) { %|`some js addition`| }
      let(:string) { %| chunk.of(#{first_string_literal}, #{second_string_literal}, #{third_string_literal})| }

      let!(:result) { sanitizer.replace_string_literals!(string) }

      it "replaces string literals with unlikely string and index" do
        expected = %| chunk.of(#{temp_double_quote}0, #{temp_single_quote}0, #{temp_interpolated_js}0)|
        expect(result).to eq(expected)
      end

      it "adds the extracted strings to the double quote strings array" do
        expect(sanitizer.removed_double_quote_strings).to include first_string_literal
        expect(sanitizer.removed_single_quote_strings).to include second_string_literal
        expect(sanitizer.removed_interpolated_js_strings).to include third_string_literal
      end

      it "ensures that each temp string has the right index attached to it" do
        expect(result).to match(/#{temp_double_quote}0/)
        expect(result).to match(/#{temp_single_quote}0/)
        expect(result).to match(/#{temp_interpolated_js}0/)
      end
    end
  end

  describe "#sanitize" do

    let(:complex_string) do
      %| Some.new("code")
        with('lots of', 'strings\\'n', "such")
        `some interpolated js`
        `there and
        here`
        "there are also \\n
        multi-line strings with random \\"escaped quotes \\" "
       |
    end
    let(:removed_double_quote_strings) { sanitizer.removed_double_quote_strings }
    let(:removed_single_quote_strings) { sanitizer.removed_single_quote_strings }
    let(:removed_interpolated_js_strings) { sanitizer.removed_interpolated_js_strings }

    let!(:result) { sanitizer.sanitize(complex_string) }

    it "replaces escaped quotes" do
      expect(removed_single_quote_strings.any?{ |s| s.match(temp_single_quote_char)})
        .to be_true
      expect(removed_double_quote_strings.any?{ |s| s.match(temp_double_quote_char)})
        .to be_true
    end

    it "replaces all types of string literal" do
      expect(result.any?{ |s| s.match(temp_single_quote + 0.to_s) })
        .to be_true
      expect(result.any?{ |s| s.match(temp_single_quote + 1.to_s) })
        .to be_true
      expect(result.none?{ |s| s.match(temp_single_quote + 2.to_s) })
        .to be_true

      expect(result.any?{ |s| s.match(temp_double_quote + 0.to_s)})
        .to be_true
      expect(result.any?{ |s| s.match(temp_double_quote + 1.to_s)})
        .to be_true
      expect(result.any?{ |s| s.match(temp_double_quote + 2.to_s)})
        .to be_true
      expect(result.none?{ |s| s.match(temp_double_quote + 3.to_s)})
        .to be_true

      expect(result.any?{ |s| s.match(temp_interpolated_js + 0.to_s) })
        .to be_true
      expect(result.any?{ |s| s.match(temp_interpolated_js + 1.to_s) })
        .to be_true
    end

    it "returns text that doesn't contain escaped quotes or string literals" do
      expect(result.none?{ |s| s.match(temp_single_quote_char) })
        .to be_true
      expect(result.none?{ |s| s.match(temp_double_quote_char) })
        .to be_true

      expect(result.none?{ |s| s.match(Cocaine::Patterns::SINGLE_QUOTES_STRING) })
        .to be_true
      expect(result.none?{ |s| s.match(Cocaine::Patterns::DOUBLE_QUOTES_STRING) })
        .to be_true
      expect(result.none?{ |s| s.match(Cocaine::Patterns::INTERPOLATED_JS_STRING) })
        .to be_true
    end
  end

  describe "#split" do
    let(:chunk_1) { "more.code" }
    let(:chunk_2) { "split(via)" }
    let(:chunk_3) { "semi - colon" }

    let(:line_1) { "code.with some_variable" }
    let(:line_2) { "#{chunk_1}; ;#{chunk_2}; #{chunk_3}" }
    let(:line_3) { "and newlines" }

    let(:text)  do
      "#{line_1}
       #{line_2}
       #{line_3}"
    end

    it "splits the text by new line and by semicolon" do
      expected = [
        line_1,
        chunk_1,
        chunk_2,
        chunk_3,
        line_3
      ]
      expect(sanitizer.split(text)).to eq(expected)
    end
  end
end
