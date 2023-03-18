"Filed out from Dolphin Smalltalk"!

Kernel.StValueToken
	subclass: #'Kernel.StIllegalCharacterToken'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StIllegalCharacterToken guid: (Core.GUID fromString: '{3aa6518c-788d-479b-b7c3-2988a870dde6}')!
Kernel.StIllegalCharacterToken comment: ''!
!Kernel.StIllegalCharacterToken categoriesForClass!System-Compiler! !
!Kernel.StIllegalCharacterToken methodsFor!

acceptVisitor: aTokenVisitor
	^aTokenVisitor visitIllegalCharacterToken: self!

length
	^1! !
!Kernel.StIllegalCharacterToken categoriesForMethods!
acceptVisitor:!public!visitor! !
length!accessing!private! !
!

