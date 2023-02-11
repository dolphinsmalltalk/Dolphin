"Filed out from Dolphin Smalltalk"!

Kernel.StValueToken subclass: #'Kernel.StLiteralArrayToken'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StLiteralArrayToken guid: (Core.GUID fromString: '{93797e84-0be7-4528-8362-983d06286a99}')!
Kernel.StLiteralArrayToken comment: ''!
!Kernel.StLiteralArrayToken methodsFor!

acceptVisitor: aTokenVisitor
	^aTokenVisitor visitLiteralArrayToken: self!

isLiteralArrayToken
	^true! !
!Kernel.StLiteralArrayToken categoriesForMethods!
acceptVisitor:!public!visitor! !
isLiteralArrayToken!public!testing! !
!

