"Filed out from Dolphin Smalltalk X6"!

StValueToken subclass: #StBinarySelectorToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StBinarySelectorToken guid: (GUID fromString: '{D3AA3980-63D1-4EA8-9654-F8FB9CBA525D}')!
StBinarySelectorToken comment: ''!
!StBinarySelectorToken categoriesForClass!System-Compiler! !
!StBinarySelectorToken methodsFor!

acceptVisitor: aTokenVisitor 
	^aTokenVisitor acceptBinarySelectorToken: self!

isBinary
	^true!

isBinary: aSymbol
	"Answer whether the receiver is a binary token with the specified value."

	^self value == aSymbol! !
!StBinarySelectorToken categoriesFor: #acceptVisitor:!public!visitor! !
!StBinarySelectorToken categoriesFor: #isBinary!public!testing! !
!StBinarySelectorToken categoriesFor: #isBinary:!public!testing! !

