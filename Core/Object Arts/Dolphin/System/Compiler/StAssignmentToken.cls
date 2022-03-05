"Filed out from Dolphin Smalltalk"!

StToken subclass: #StAssignmentToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StAssignmentToken guid: (GUID fromString: '{6aeed410-71e0-440f-a815-2307b61f7693}')!
StAssignmentToken comment: ''!
!StAssignmentToken categoriesForClass!System-Compiler! !
!StAssignmentToken methodsFor!

acceptVisitor: aTokenVisitor
	^aTokenVisitor visitAssignmentToken: self!

isAssignment
	^true!

length
	^2! !
!StAssignmentToken categoriesForMethods!
acceptVisitor:!public!visitor! !
isAssignment!public!testing! !
length!accessing!private! !
!

