class Cocaine::Sanitizer

  attr_accessor :removed_double_quote_strings,
    :removed_single_quote_strings

  SINGLE_REPLACEMENT_CHAR = "COCAINE_SINGLE_REPLACEMENT_CHAR"
  DOUBLE_REPLACEMENT_CHAR = "COCAINE_DOUBLE_REPLACEMENT_CHAR"

  ESCAPED_QUOTES_MAP = {
    Cocaine::Patterns::ESCAPED_SINGLE_QUOTE => SINGLE_REPLACEMENT_CHAR,
    Cocaine::Patterns::ESCAPED_DOUBLE_QUOTE => DOUBLE_REPLACEMENT_CHAR
  }

  SINGLE_REPLACEMENT_STRING = "COCAINE_SINGLE_REPLACEMENT_STRING_"
  DOUBLE_REPLACEMENT_STRING = "COCAINE_DOUBLE_REPLACEMENT_STRING_"

  STRING_LITERAL_MAP = {
    single: {
      pattern: Cocaine::Patterns::SINGLE_QUOTES_STRING,
      replacement: SINGLE_REPLACEMENT_STRING
    },
    double: {
      pattern: Cocaine::Patterns::DOUBLE_QUOTES_STRING,
      replacement: DOUBLE_REPLACEMENT_STRING
    }
  }

  def initialize
    self.removed_double_quote_strings = []
    self.removed_single_quote_strings = []
  end

  def sanitize(text)
    processed_text = replace_escaped_quotes(text)
    replace_string_literals(processed_text)
  end

  def replace_escaped_quotes(text)
    text_clone = text.clone

    ESCAPED_QUOTES_MAP.each do |quote, replacement|
      text_clone.gsub!(quote, replacement)
    end
    text_clone
  end

  def replace_string_literals(text)
    text_clone = text.clone

    STRING_LITERAL_MAP.each do |type, info|
      replace_type_of_literal(info.merge(type: type, text: text_clone))
    end
    text_clone
  end

  private

  def replace_type_of_literal(options)
    while match = options[:text].match(options[:pattern])
      removed_strings = send("removed_#{options[:type]}_quote_strings")
      index = removed_strings.size
      removed_strings << match["string"]
      options[:text].sub!(options[:pattern], "#{options[:replacement]}#{index}")
    end
  end

end
