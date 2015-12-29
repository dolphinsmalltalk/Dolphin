"Filed out from Dolphin Smalltalk X6"!

StToken subclass: #StAssignmentToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StAssignmentToken guid: (GUID fromString: '{6AEED410-71E0-440F-A815-2307B61F7693}')!
StAssignmentToken comment: ''!
!StAssignmentToken categoriesForClass!System-Compiler! !
!StAssignmentToken methodsFor!

acceptVisitor: aTokenVisitor 
	^aTokenVisitor acceptAssignmentToken: self!

isAssignment
	^true!

length
	^2! !
!StAssignmentToken categoriesFor: #acceptVisitor:!public!visitor! !
!StAssignmentToken categoriesFor: #isAssignment!public!testing! !
!StAssignmentToken categoriesFor: #length!accessing!private! !

