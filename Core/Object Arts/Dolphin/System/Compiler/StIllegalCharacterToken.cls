"Filed out from Dolphin Smalltalk X6"!

StValueToken subclass: #StIllegalCharacterToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StIllegalCharacterToken guid: (GUID fromString: '{3AA6518C-788D-479B-B7C3-2988A870DDE6}')!
StIllegalCharacterToken comment: ''!
!StIllegalCharacterToken categoriesForClass!System-Compiler! !
!StIllegalCharacterToken methodsFor!

acceptVisitor: aTokenVisitor 
	^aTokenVisitor acceptIllegalCharacterToken: self!

length
	^1! !
!StIllegalCharacterToken categoriesFor: #acceptVisitor:!public!visitor! !
!StIllegalCharacterToken categoriesFor: #length!accessing!private! !

