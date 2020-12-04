"Filed out from Dolphin Smalltalk 7"!

Kernel.StLocalVariable subclass: #'Kernel.StTempVariable'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StTempVariable guid: (Core.GUID fromString: '{2e234643-1178-4555-82a1-edb3c4317d7a}')!
Kernel.StTempVariable comment: '<StTempVariable> is a specialised class of <StLocalVariable>to describe method and block temporary definitions.'!
!Kernel.StTempVariable categoriesForClass!Kernel-Objects! !
!Kernel.StTempVariable methodsFor!

isTempVariable
	"Answer whether the receiver describes a temporary variable."

	^true! !
!Kernel.StTempVariable categoriesFor: #isTempVariable!public!testing! !

