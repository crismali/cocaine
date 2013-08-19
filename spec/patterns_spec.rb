require_relative "./spec_helper"

describe Cocaine::Patterns do

  describe "METHOD_DEF" do

    let(:pattern) { Cocaine::Patterns::METHOD_DEF }

    let(:simple_method) { "def my_method\n" }
    let(:other_simple_method) { "def my_other_method\n" }

    it "captures the method name" do
      result_1 = simple_method.match pattern
      expect(result_1).to_not be_nil
      expect(result_1["method_name"]).to eq("my_method")

      result_2 = other_simple_method.match pattern
      expect(result_2).to_not be_nil
      expect(result_2["method_name"]).to eq("my_other_method")
    end

    context "when the method name has a number in it" do
      it "captures the method name" do
        number_method = "def method_1\n"
        result = number_method.match pattern
        expect(result).to_not be_nil
        expect(result["method_name"]).to eq("method_1")
      end
    end

    context "when the method name has spaces in front of it" do
      it "captures the method name" do
        spaced_method = "   def method\n"
        result = spaced_method.match pattern
        expect(result).to_not be_nil
        expect(result["method_name"]).to eq("method")
      end
    end

    context "when the method name has a question mark in it" do
      let(:predicate_method) { "def my_method?\n" }

      it "captures the method name" do
        result = predicate_method.match pattern
        expect(result).to_not be_nil
        expect(result["method_name"]).to eq("my_method?")
      end
    end

    context "when the method has arguments" do
      it "captures the arguments list when there are parentheses" do
        method_with_parens = "def method(arg_1, arg_2)\n"
        result = method_with_parens.match pattern
        expect(result["args_list"]).to eq("arg_1, arg_2")
      end

      it "captures the arguments list when there are parentheses" do
        method_without_parens = "def method arg_1, arg_2\n"
        result = method_without_parens.match pattern
        expect(result["args_list"]).to eq("arg_1, arg_2")
      end

      it "captures the argument list when there's only one argument" do
        method = "def method(arg)\n"
        result = method.match pattern
        expect(result["args_list"]).to eq("arg")
      end
    end

    context "when the method is a singleton" do
      it "captures the method name" do
        singleton = "def self.method\n"
        result = singleton.match pattern
        expect(result).to_not be_nil
        expect(result["method_name"]).to eq("method")
        expect(result["singleton"]).to eq("self.")
      end

      it "captures the argument list" do
        singleton = "def self.method arg_1\n"
        result = singleton.match pattern
        expect(result).to_not be_nil
        expect(result["args_list"]).to eq("arg_1")
        expect(result["singleton"]).to eq("self.")
      end
    end
  end
end
