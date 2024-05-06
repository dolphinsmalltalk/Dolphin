"Filed out from Dolphin Smalltalk"!

StValueToken subclass: #StIllegalCharacterToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StIllegalCharacterToken guid: (GUID fromString: '{3aa6518c-788d-479b-b7c3-2988a870dde6}')!

StIllegalCharacterToken comment: ''!

!StIllegalCharacterToken categoriesForClass!System-Compiler! !

!StIllegalCharacterToken methodsFor!

acceptVisitor: aTokenVisitor
	^aTokenVisitor visitIllegalCharacterToken: self!

length
	^1! !

!StIllegalCharacterToken categoriesForMethods!
acceptVisitor:!public!visitor! !
length!accessing!private! !
!

