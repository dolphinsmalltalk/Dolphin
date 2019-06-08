"Filed out from Dolphin Smalltalk 7"!

StLocalVariable subclass: #StPrimitiveFailureVariable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StPrimitiveFailureVariable guid: (GUID fromString: '{4231a299-1e20-45b5-8dc9-4ac9a57f70d6}')!
StPrimitiveFailureVariable comment: ''!
!StPrimitiveFailureVariable categoriesForClass!Kernel-Objects! !
!StPrimitiveFailureVariable methodsFor!

isConstant
	"Answer whether the receiver describes a reference to a variable that has a constant value.
	Arguments cannot be assigned to in Smalltalk."

	^true! !
!StPrimitiveFailureVariable categoriesFor: #isConstant!public!testing! !

