"Filed out from Dolphin Smalltalk 7"!

Kernel.StLocalVariable subclass: #'Kernel.StGeneratedTempVariable'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StGeneratedTempVariable guid: (Core.GUID fromString: '{4231a299-1e20-45b5-8dc9-4ac9a57f70d6}')!
Kernel.StGeneratedTempVariable comment: '<StGeneratedTempVariable> is a specialised class of <StLocalVariable>to describe compiler generated temporary variables such as the `_failureCode` variable of primitive methods which the primitive uses to pass a failure reason to the Smalltalk backup code.'!
!Kernel.StGeneratedTempVariable categoriesForClass!Kernel-Objects! !
!Kernel.StGeneratedTempVariable methodsFor!

isConstant
	"Answer whether the receiver describes a reference to a variable that has a constant value.
	Arguments cannot be assigned to in Smalltalk."

	^true! !
!Kernel.StGeneratedTempVariable categoriesFor: #isConstant!public!testing! !

