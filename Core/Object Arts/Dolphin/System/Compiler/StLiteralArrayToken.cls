"Filed out from Dolphin Smalltalk X6"!

StValueToken subclass: #StLiteralArrayToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StLiteralArrayToken guid: (GUID fromString: '{93797E84-0BE7-4528-8362-983D06286A99}')!
StLiteralArrayToken comment: ''!
!StLiteralArrayToken categoriesForClass!Unclassified! !
!StLiteralArrayToken methodsFor!

acceptVisitor: aTokenVisitor 
	^aTokenVisitor acceptLiteralArrayToken: self!

isForByteArray
	^value last == $[!

isLiteralArrayToken
	^true! !
!StLiteralArrayToken categoriesFor: #acceptVisitor:!public!visitor! !
!StLiteralArrayToken categoriesFor: #isForByteArray!public!testing! !
!StLiteralArrayToken categoriesFor: #isLiteralArrayToken!public!testing! !

