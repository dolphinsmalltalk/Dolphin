"Filed out from Dolphin Smalltalk"!

StValueToken subclass: #StSpecialCharacterToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StSpecialCharacterToken guid: (GUID fromString: '{6d27cd5e-b145-43c8-b556-242906a6b9d8}')!
StSpecialCharacterToken comment: ''!
!StSpecialCharacterToken categoriesForClass!System-Compiler! !
!StSpecialCharacterToken methodsFor!

acceptVisitor: aTokenVisitor
	^aTokenVisitor visitSpecialCharacterToken: self!

isSpecial
	^true!

isSpecial: aCharacter
	^self value == aCharacter!

length
	^1! !
!StSpecialCharacterToken categoriesForMethods!
acceptVisitor:!public!visitor! !
isSpecial!public!testing! !
isSpecial:!public!testing! !
length!accessing!private! !
!

