"Filed out from Dolphin Smalltalk X6"!

StValueToken subclass: #StSpecialCharacterToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StSpecialCharacterToken guid: (GUID fromString: '{6D27CD5E-B145-43C8-B556-242906A6B9D8}')!
StSpecialCharacterToken comment: ''!
!StSpecialCharacterToken categoriesForClass!System-Compiler! !
!StSpecialCharacterToken methodsFor!

acceptVisitor: aTokenVisitor 
	^aTokenVisitor acceptSpecialCharacterToken: self!

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

