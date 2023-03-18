"Filed out from Dolphin Smalltalk"!

Kernel.StValueToken
	subclass: #'Kernel.StLiteralByteArrayToken'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StLiteralByteArrayToken guid: (Core.GUID fromString: '{6acc5452-14fa-4ecd-8720-c75e3d6458a9}')!
Kernel.StLiteralByteArrayToken comment: ''!
!Kernel.StLiteralByteArrayToken categoriesForClass!System-Compiler! !
!Kernel.StLiteralByteArrayToken methodsFor!

acceptVisitor: aTokenVisitor
	^aTokenVisitor visitLiteralByteArrayToken: self!

isLiteralByteArrayToken
	^true! !
!Kernel.StLiteralByteArrayToken categoriesForMethods!
acceptVisitor:!public!visitor! !
isLiteralByteArrayToken!public!testing! !
!

