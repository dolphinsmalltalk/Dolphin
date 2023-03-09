"Filed out from Dolphin Smalltalk"!

Kernel.StLiteralToken
	subclass: #'Kernel.StLiteralSymbolToken'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StLiteralSymbolToken guid: (Core.GUID fromString: '{c492fa20-8940-4822-a908-62f30a951c68}')!
Kernel.StLiteralSymbolToken comment: ''!
!Kernel.StLiteralSymbolToken methodsFor!

formatOn: aStream source: aString
	aStream nextPut: $#.
	((Scanner isSelector: value) and: [value ~~ #'||'])
		ifTrue: [aStream nextPutAll: value]
		ifFalse: [value asString printOn: aStream]!

valueClass
	^Symbol! !
!Kernel.StLiteralSymbolToken categoriesForMethods!
formatOn:source:!public! !
valueClass!public! !
!

