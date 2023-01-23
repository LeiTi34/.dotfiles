; extends

(
 (attribute
   object: (identifier) @_path (#eq? @_path "textwrap")
   attribute: (identifier) @_name (#eq? @_name "dedent"))
 (argument_list
   (string) @sql)
   ; (#offset! @sql 1 0 0 0)
)
