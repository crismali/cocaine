module Cocaine::Matcher

  def self.parse(string, regexp)
    matches = string.match regexp
    return nil unless matches
    Hash[matches.names.zip(matches.captures)]
  end

end
