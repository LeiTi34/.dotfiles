; extends

; ; Inject into __doc__ = textwrap.dedent('...') as markdown
; (
;  (assignment
;    left: (identifier) @_variable (#eq? @_variable "__doc__")
;    right: (call
;             (attribute
;               object: (identifier) @_path (#eq? @_path "textwrap")
;               attribute: (identifier) @_name (#eq? @_name "dedent"))
;             (argument_list
;               (string) @markdown)
;             )
;    )
;  )

; Inject into textwrap.dedent('...') as sql
(
 (attribute
   object: (identifier) @_path (#eq? @_path "textwrap")
   attribute: (identifier) @_name (#eq? @_name "dedent"))
 (argument_list
   (string) @sql)
 ; (#offset! @sql 1 0 0 0)
)

; Inject into Foo(sql='...') as sql
(
 (keyword_argument
   name: (identifier) @_name (#eq? @_name "sql")
   value: (string) @sql)
) 
