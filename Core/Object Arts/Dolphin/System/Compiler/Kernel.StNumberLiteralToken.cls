"Filed out from Dolphin Smalltalk"!

Kernel.StLiteralTokenWithSource
	subclass: #'Kernel.StNumberLiteralToken'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StNumberLiteralToken guid: (Core.GUID fromString: '{777f55ae-a939-4a73-9cc8-2cef3a91f41e}')!
Kernel.StNumberLiteralToken comment: ''!
!Kernel.StNumberLiteralToken methodsFor!

acceptVisitor: aTokenVisitor
	^aTokenVisitor visitNumberLiteralToken: self!

forgetNegative
	value := value negated.
	source := source copyFrom: 2.
	start := start + 1!

isNegative
	^self value negative!

isNumberLiteralToken
	^true! !
!Kernel.StNumberLiteralToken categoriesForMethods!
acceptVisitor:!public!visitor! !
forgetNegative!helpers!private! !
isNegative!public!testing! !
isNumberLiteralToken!public!testing! !
!

