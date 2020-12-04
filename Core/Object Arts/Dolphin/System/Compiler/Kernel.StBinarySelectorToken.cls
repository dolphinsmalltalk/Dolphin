"Filed out from Dolphin Smalltalk 7"!

Kernel.StValueToken subclass: #'Kernel.StBinarySelectorToken'
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

	^self value == aSymbol! !
!Kernel.StBinarySelectorToken categoriesFor: #acceptVisitor:!public!visitor! !
!Kernel.StBinarySelectorToken categoriesFor: #isBinary!public!testing! !
!Kernel.StBinarySelectorToken categoriesFor: #isBinary:!public!testing! !

