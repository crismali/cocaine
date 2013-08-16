require_relative "./spec_helper"

describe Cocaine::Matcher do

  let(:matcher) { Cocaine::Matcher }

  describe "#parse" do

    let(:string) { "Hello, how are you?" }
    let(:regexp) { /(?<greeting>\w+),\s(?<question>.+)(?<question_mark>\?)/ }


    it "takes a regexp and string and returns a hash of the named matches" do
      result = matcher.parse string, regexp
      expected = {
        "greeting" => "Hello",
        "question" => "how are you",
        "question_mark" => "?"
      }
      expect(result).to eq(expected)
    end

    context "when the string doesn't fully match" do
      let(:bad_string) { "Hello, I'm well." }

      it "returns nil" do
        result = matcher.parse bad_string, regexp
        expect(result).to be_nil
      end
    end
  end

end
