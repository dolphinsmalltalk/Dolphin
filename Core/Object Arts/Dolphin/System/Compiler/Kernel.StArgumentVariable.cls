"Filed out from Dolphin Smalltalk"!

Kernel.StLocalVariable subclass: #'Kernel.StArgumentVariable'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StArgumentVariable guid: (Core.GUID fromString: '{724d61eb-4b75-4eec-9d01-58a4af61ee45}')!
Kernel.StArgumentVariable comment: '<StArgumentVariable> is a specialised class of <StLocalVariable> to describe method and block parameters (argument definitions).'!
!Kernel.StArgumentVariable categoriesForClass!Kernel-Objects! !
!Kernel.StArgumentVariable methodsFor!

addAssignment: aStVariableNode fromScope: aStSemanticScope
	self error: 'Illegal assignment to constant.'!

isArgument
	"Answer whether the receiver describes an argument variable."

	^true!

isConstant
	"Answer whether the receiver describes a reference to a variable that has a constant value.
	Arguments cannot be assigned to in Smalltalk."

	^true! !
!Kernel.StArgumentVariable categoriesForMethods!
addAssignment:fromScope:!public! !
isArgument!public!testing! !
isConstant!public!testing! !
!

