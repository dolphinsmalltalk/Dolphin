"Filed out from Dolphin Smalltalk"!

StVariable subclass: #StSpecialVariable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StSpecialVariable guid: (GUID fromString: '{83bccab3-8ad0-4dbb-bbf0-dba008295503}')!
StSpecialVariable comment: '<StSpecialVariable> is an abstract class of <StVariable> with concrete subclasses to describe the special variables, ''self'', ''super'', and ''thisContext''. '!
!StSpecialVariable categoriesForClass!Kernel-Objects! !
!StSpecialVariable methodsFor!

isConstant
	"Answer whether the receiver describes a variable that has a constant value. The special
	variables self, super and thisContext, cannot be assigned to."

	^true! !
!StSpecialVariable categoriesForMethods!
isConstant!public!testing! !
!

