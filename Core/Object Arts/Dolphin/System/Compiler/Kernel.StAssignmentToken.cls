"Filed out from Dolphin Smalltalk"!

Kernel.StToken
	subclass: #'Kernel.StAssignmentToken'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StAssignmentToken guid: (Core.GUID fromString: '{6aeed410-71e0-440f-a815-2307b61f7693}')!
Kernel.StAssignmentToken comment: ''!
!Kernel.StAssignmentToken categoriesForClass!System-Compiler! !
!Kernel.StAssignmentToken methodsFor!

acceptVisitor: aTokenVisitor
	^aTokenVisitor visitAssignmentToken: self!

isAssignment
	^true!

length
	^2! !
!Kernel.StAssignmentToken categoriesForMethods!
acceptVisitor:!public!visitor! !
isAssignment!public!testing! !
length!accessing!private! !
!

