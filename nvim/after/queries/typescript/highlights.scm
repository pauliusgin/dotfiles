; extends
; TextMate `variable.other.object` — identifier that is the object of a
; member access (`Foo` in `Foo.bar`). Priority 200 beats LSP semantic
; tokens (125), which only see it as a plain `variable`.
((member_expression
   object: (identifier) @variable.object)
 (#set! "priority" 200))
