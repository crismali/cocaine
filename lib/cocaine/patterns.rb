module Cocaine::Patterns

  METHOD_DEF = /def \s
    (?<singleton>self\.)?
    (?<method_name>[\w\?]+)
    \(? \s* (?<args_list>[\w\s,]*) \s* \)?
    \n /x

end
