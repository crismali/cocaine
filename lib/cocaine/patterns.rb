module Cocaine::Patterns

  METHOD_DEF = /\s* def \s*
    (?<method_name>[\w\?\.]+)
    \s* \(? \s*
      (?<args_list>[^\)\(\;\n\|]*)
    \s* \)? \s*
    [\n\;]
  /x

  INITIALIZE = /
    (?<initialize>\A initialize \z)
  /x

  SINGLETON = /
    (?<singleton>self\s*\.)
  /x

  CLASS_MODULE_DEF = / \s*
    (class|module) \s+
    (?<class_module>[\w\:\d]+)
    \s* <? \s*
    (?<super_class_name>[\w\:\d]*)
    \s*
    [\n\;]
  /x

  IF_ELSIF_ELSE_UNLESS = / \s*
    (?<conditional>if | elsif | else | unless) \s*
    (?<condition>.+)? \s*
    [\n\;]
  /x

  ELSIF = /(?<elsif>elsif)/x

  INLINE_IF_UNLESSS = /
    (?<expression>.+)
    \s+ (?<conditional>if | unless) \s+
    (?<condition>.+)
    [\n\;]
  /x

  DO_BASIC = /
    (?<expression>.+)
      \s do \s*
    (?<args_list>.*)
    [\n\;]
  /x

  BLOCK_ARGS_LIST = /
    \| \s*
      (?<args_list>.+)
    \s* \|
  /x

end
