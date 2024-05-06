"Filed out from Dolphin Smalltalk"!

StLocalVariable subclass: #StArgumentVariable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StArgumentVariable guid: (GUID fromString: '{724d61eb-4b75-4eec-9d01-58a4af61ee45}')!

StArgumentVariable comment: '<StArgumentVariable> is a specialised class of <StLocalVariable> to describe method and block parameters (argument definitions).'!

!StArgumentVariable categoriesForClass!Kernel-Objects! !

!StArgumentVariable methodsFor!

isArgument
	"Answer whether the receiver describes an argument variable."

	^true!

isConstant
	"Answer whether the receiver describes a reference to a variable that has a constant value.
	Arguments cannot be assigned to in Smalltalk."

	^true! !

!StArgumentVariable categoriesForMethods!
isArgument!public!testing! !
isConstant!public!testing! !
!

