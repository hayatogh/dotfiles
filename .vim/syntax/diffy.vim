if exists("b:current_syntax")
  finish
endif

syn match diffOnly	"^Only in .*"
syn match diffIdentical	"^Files .* and .* are identical$"
syn match diffDiffer	"^Files .* and .* differ$"
syn match diffBDiffer	"^Binary files .* and .* differ$"
syn match diffIsA	"^File .* is a .* while file .* is a .*"
syn match diffNoEOL	"^\\ No newline at end of file .*"
syn match diffCommon	"^Common subdirectories: .*"

syn match diffRemoved	"^.*\s<$"
syn match diffAdded	"^\s\+>\s.*"
syn match diffChanged	"^.*\s|\s.*$"

syn match diffSubname	" @@..*"ms=s+3 contained
syn match diffLine	"^@.*" contains=diffSubname
syn match diffLine	"^\<\d\+\>.*"
syn match diffLine	"^\*\*\*\*.*"
syn match diffLine	"^---$"

" Some versions of diff have lines like "#c#" and "#d#" (where # is a number)
syn match diffLine	"^\d\+\(,\d\+\)\=[cda]\d\+\>.*"

syn match diffFile	"^diff\>.*"
syn match diffFile	"^+++ .*"
syn match diffFile	"^Index: .*"
syn match diffFile	"^==== .*"
syn match diffOldFile	"^\*\*\* .*"
syn match diffNewFile	"^--- .*"

" Used by git
syn match diffIndexLine	"^index \x\x\x\x.*"

syn match diffComment	"^#.*"

" Define the default highlighting.
" Only used when an item doesn't have highlighting yet
hi def link diffOldFile		diffFile
hi def link diffNewFile		diffFile
hi def link diffIndexLine	PreProc
hi def link diffFile		Type
hi def link diffOnly		Constant
hi def link diffIdentical	Constant
hi def link diffDiffer		Constant
hi def link diffBDiffer		Constant
hi def link diffIsA		Constant
hi def link diffNoEOL		Constant
hi def link diffCommon		Constant
hi def link diffRemoved		Special
hi def link diffChanged		PreProc
hi def link diffAdded		Identifier
hi def link diffLine		Statement
hi def link diffSubname		PreProc
hi def link diffComment		Comment

let b:current_syntax = "diffy"
