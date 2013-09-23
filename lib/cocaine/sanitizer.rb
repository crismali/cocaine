class Cocaine::Sanitizer

  attr_accessor :removed_strings

  ESCAPED_QUOTES_MAP = {
    Cocaine::Patterns::ESCAPED_SINGLE_QUOTE => "COCAINE_SINGLE_QUOTE_STR",
    Cocaine::Patterns::ESCAPED_DOUBLE_QUOTE => "COCAINE_DOUBLE_QUOTE_STR"
  }

  STRING_LITERAL_MAP = {
    Cocaine::Patterns::SINGLE_QUOTES_STRING => "COCAINE_SINGLE_STRING_coke",
    Cocaine::Patterns::DOUBLE_QUOTES_STRING => "COCAINE_DOUBLE_STRING_coke"
  }

  def initialize
    self.removed_strings = []
  end

  def replace_escaped_quotes(text)
    text_clone = text.clone

    ESCAPED_QUOTES_MAP.each do |quote, replacement|
      text_clone.gsub!(quote, replacement)
    end
    text_clone
  end

  # def replace_string_literals(text)
  #   quotes = []
  #   STRING_LITERAL_MAP.each do |quote, replacement_template|
  #     match = text.match quote
  #     while match
  #       index = quotes.size
  #       quotes << match["string"]
  #       text.sub!(quote, "#{replacement_template}#{index}")
  #     end
  #   end
  # end

end
