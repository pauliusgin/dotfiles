; extends
; TextMate `variable.other.object` — object of a member access (`Foo` in
; `Foo.bar`). Priority 200 beats LSP semantic tokens (125).
((member_expression
   object: (identifier) @variable.object)
 (#set! "priority" 200))
