"Filed out from Dolphin Smalltalk 7"!

StValueToken subclass: #StIllegalCharacterToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StIllegalCharacterToken guid: (GUID fromString: '{3aa6518c-788d-479b-b7c3-2988a870dde6}')!
StIllegalCharacterToken comment: ''!
!StIllegalCharacterToken categoriesForClass!System-Compiler! !
!StIllegalCharacterToken methodsFor!

acceptVisitor: aTokenVisitor
	^aTokenVisitor visitIllegalCharacterToken: self!

length
	^1! !
!StIllegalCharacterToken categoriesFor: #acceptVisitor:!public!visitor! !
!StIllegalCharacterToken categoriesFor: #length!accessing!private! !

