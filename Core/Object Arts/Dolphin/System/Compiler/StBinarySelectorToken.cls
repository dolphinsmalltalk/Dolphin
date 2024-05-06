"Filed out from Dolphin Smalltalk"!

StValueToken subclass: #StBinarySelectorToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StBinarySelectorToken guid: (GUID fromString: '{d3aa3980-63d1-4ea8-9654-f8fb9cba525d}')!

StBinarySelectorToken comment: ''!

!StBinarySelectorToken categoriesForClass!System-Compiler! !

!StBinarySelectorToken methodsFor!

acceptVisitor: aTokenVisitor
	^aTokenVisitor visitBinarySelectorToken: self!

isBinary
	^true!

isBinary: aSymbol
	"Answer whether the receiver is a binary token with the specified value."

	^self value == aSymbol! !

!StBinarySelectorToken categoriesForMethods!
acceptVisitor:!public!visitor! !
isBinary!public!testing! !
isBinary:!public!testing! !
!

