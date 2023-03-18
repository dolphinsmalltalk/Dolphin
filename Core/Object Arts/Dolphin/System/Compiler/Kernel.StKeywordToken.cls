"Filed out from Dolphin Smalltalk"!

Kernel.StValueToken
	subclass: #'Kernel.StKeywordToken'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StKeywordToken guid: (Core.GUID fromString: '{e61c129a-266f-46b1-a320-25df7d71ac8f}')!
Kernel.StKeywordToken comment: ''!
!Kernel.StKeywordToken categoriesForClass!System-Compiler! !
!Kernel.StKeywordToken methodsFor!

acceptVisitor: aTokenVisitor
	^aTokenVisitor visitKeywordToken: self!

isKeyword
	^true! !
!Kernel.StKeywordToken categoriesForMethods!
acceptVisitor:!public!visitor! !
isKeyword!public!testing! !
!

