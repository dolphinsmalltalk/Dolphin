"Filed out from Dolphin Smalltalk"!

Kernel.StValueToken
	subclass: #'Kernel.StBinarySelectorToken'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StBinarySelectorToken guid: (Core.GUID fromString: '{d3aa3980-63d1-4ea8-9654-f8fb9cba525d}')!
Kernel.StBinarySelectorToken comment: ''!
!Kernel.StBinarySelectorToken categoriesForClass!System-Compiler! !
!Kernel.StBinarySelectorToken methodsFor!

acceptVisitor: aTokenVisitor
	^aTokenVisitor visitBinarySelectorToken: self!

isBinary
	^true!

isBinary: aSymbol
	"Answer whether the receiver is a binary token with the specified value."

	^self value == aSymbol!

isBinaryStarting: aCharacter
	"Answer whether the receiver is a binary selector token starting with the specified <Character>."

	"We know that the characters of binary selectors are all ASCII, so we can just identity compare against the first code unit"

	^(value at: 1) == aCharacter!

trimFirst
	"Private - Trim the first character from the selector because the parser has recognised it as a preceding token and not part of this binary token"

	value := (value copyFrom: 2) asSymbol.
	start := start + 1! !
!Kernel.StBinarySelectorToken categoriesForMethods!
acceptVisitor:!public!visitor! !
isBinary!public!testing! !
isBinary:!public!testing! !
isBinaryStarting:!public!testing! !
trimFirst!helpers!private! !
!

