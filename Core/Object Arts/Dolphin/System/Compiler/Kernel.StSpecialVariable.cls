"Filed out from Dolphin Smalltalk 7"!

Kernel.StVariable subclass: #'Kernel.StSpecialVariable'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StSpecialVariable guid: (Core.GUID fromString: '{83bccab3-8ad0-4dbb-bbf0-dba008295503}')!
Kernel.StSpecialVariable comment: '<StSpecialVariable> is an abstract class of <StVariable> with concrete subclasses to describe the special variables, ''self'', ''super'', and ''thisContext''. '!
!Kernel.StSpecialVariable categoriesForClass!Kernel-Objects! !
!Kernel.StSpecialVariable methodsFor!

isConstant
	"Answer whether the receiver describes a variable that has a constant value. The special
	variables self, super and thisContext, cannot be assigned to."

	^true! !
!Kernel.StSpecialVariable categoriesFor: #isConstant!public!testing! !

