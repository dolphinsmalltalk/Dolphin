"Filed out from Dolphin Smalltalk"!

StValueToken subclass: #StLiteralArrayToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StLiteralArrayToken guid: (GUID fromString: '{93797e84-0be7-4528-8362-983d06286a99}')!

StLiteralArrayToken comment: ''!

!StLiteralArrayToken categoriesForClass!Unclassified! !

!StLiteralArrayToken methodsFor!

acceptVisitor: aTokenVisitor
	^aTokenVisitor visitLiteralArrayToken: self!

isForByteArray
	^value last == $[!

isLiteralArrayToken
	^true! !

!StLiteralArrayToken categoriesForMethods!
acceptVisitor:!public!visitor! !
isForByteArray!public!testing! !
isLiteralArrayToken!public!testing! !
!

