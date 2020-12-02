"Filed out from Dolphin Smalltalk 7"!

StToken subclass: #StAssignmentToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!StAssignmentToken categoriesFor: #acceptVisitor:!public!visitor! !
!StAssignmentToken categoriesFor: #isAssignment!public!testing! !
!StAssignmentToken categoriesFor: #length!accessing!private! !

