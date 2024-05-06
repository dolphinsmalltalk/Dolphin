"Filed out from Dolphin Smalltalk"!

StLocalVariable subclass: #StGeneratedTempVariable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StGeneratedTempVariable guid: (GUID fromString: '{4231a299-1e20-45b5-8dc9-4ac9a57f70d6}')!

StGeneratedTempVariable comment: '<StGeneratedTempVariable> is a specialised class of <StLocalVariable>to describe compiler generated temporary variables such as the `_failureCode` variable of primitive methods which the primitive uses to pass a failure reason to the Smalltalk backup code.'!

!StGeneratedTempVariable categoriesForClass!Kernel-Objects! !

!StGeneratedTempVariable methodsFor!

isConstant
	"Answer whether the receiver describes a reference to a variable that has a constant value.
	Arguments cannot be assigned to in Smalltalk."

	^true! !

!StGeneratedTempVariable categoriesForMethods!
isConstant!public!testing! !
!

