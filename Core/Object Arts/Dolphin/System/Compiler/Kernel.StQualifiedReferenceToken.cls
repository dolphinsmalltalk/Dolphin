"Filed out from Dolphin Smalltalk"!

Kernel.StToken
	subclass: #'Kernel.StQualifiedReferenceToken'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StQualifiedReferenceToken guid: (Core.GUID fromString: '{308a8293-d6ec-4807-b588-16243c627507}')!
Kernel.StQualifiedReferenceToken comment: '`StQualifiedReferenceToken` is a kind of `StToken` to represent the opening special character sequence, #{, of a qualified reference literal.'!
!Kernel.StQualifiedReferenceToken categoriesForClass!System-Compiler! !
!Kernel.StQualifiedReferenceToken methodsFor!

acceptVisitor: aTokenVisitor
	^aTokenVisitor visitQualifiedReferenceToken: self!

isQualifiedReference
	^true!

length
	^2! !
!Kernel.StQualifiedReferenceToken categoriesForMethods!
acceptVisitor:!public!visitor! !
isQualifiedReference!helpers!public!testing! !
length!accessing!public! !
!

