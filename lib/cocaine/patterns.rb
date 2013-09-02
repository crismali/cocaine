module Cocaine::Patterns

  METHOD_DEF = /\s* def \s*
    (?<singleton>self\.)?
    (?<method_name>[\w\?]+)
    \s* \(? \s*
      (?<args_list>[^\)\(\;\n\|]*)
    \s* \)? \s*
    [\n\;]
  /x

  CLASS_MODULE_DEF = / \s*
    (class|module) \s+
    (?<class_module>[\w\:\d]+)
    \s* <? \s*
    (?<super_class_name>[\w\:\d]*)
    \s*
    [\n\;]
  /x

  IF_ELSE = / \s*
    (?<conditional>if|elsif|else) \s*
    (?<condition>.+)? \s*
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
