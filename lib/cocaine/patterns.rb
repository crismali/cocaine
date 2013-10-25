module Cocaine::Patterns

  METHOD_DEF = / def \s*
    (?<method_name>[\w\?\.]+)
    \s* \(? \s*
      (?<args_list>[^\)\(\;\n\|]*)
    \s* \)? \s*
  /x

  INITIALIZE = /
    (?<initialize>\A initialize \z)
  /x

  SINGLETON = /
    (?<singleton>self \s* \.)
  /x

  CLASS_MODULE_DEF = /
    (class|module) \s+
    (?<class>[\w\:\d]+)
    (?<super_class>.*)
  /x

  IF_ELSIF_ELSE_UNLESS = /
    \A
    (?<conditional>if | elsif | else | unless) \s*
    (?<condition>.+)? \s*
  /x

  ELSIF = / elsif /x

  INLINE_IF_UNLESS = /
    (?<expression>.+)
    \s+ (?<conditional> if | unless) \s+
    (?<condition>.+)
  /x

  DO_BASIC = /
    (?<expression>.+)
      \s do \s*
    (?<args_list>.*)
  /x

  BLOCK_ARGS_LIST = /
    \| \s*
      (?<args_list>.+)
    \s* \|
  /x

  DOUBLE_QUOTES_STRING = /
    (?<string>".*?")
  /xm

  ESCAPED_DOUBLE_QUOTE = /
    \\ \"
  /x

  SINGLE_QUOTES_STRING = /
    (?<string>'.*?')
  /xm

  ESCAPED_SINGLE_QUOTE = /
    \\ \'
  /x

  INTERPOLATION = /
    (?<expression>\#\{.+?\})
  /x

  INTERPOLATED_JS_STRING = /
    (?<string>\`.*?\`)
  /xm

end
