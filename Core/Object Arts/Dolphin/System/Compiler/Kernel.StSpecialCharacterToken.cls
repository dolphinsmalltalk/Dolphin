"Filed out from Dolphin Smalltalk 7"!

StValueToken subclass: #StSpecialCharacterToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!StSpecialCharacterToken categoriesFor: #acceptVisitor:!public!visitor! !
!StSpecialCharacterToken categoriesFor: #isSpecial!public!testing! !
!StSpecialCharacterToken categoriesFor: #isSpecial:!public!testing! !
!StSpecialCharacterToken categoriesFor: #length!accessing!private! !

