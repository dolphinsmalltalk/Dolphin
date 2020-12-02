"Filed out from Dolphin Smalltalk 7"!

StLocalVariable subclass: #StTempVariable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StTempVariable guid: (GUID fromString: '{2e234643-1178-4555-82a1-edb3c4317d7a}')!
StTempVariable comment: '<StTempVariable> is a specialised class of <StLocalVariable>to describe method and block temporary definitions.'!
!StTempVariable categoriesForClass!Kernel-Objects! !
!StTempVariable methodsFor!

isTempVariable
	"Answer whether the receiver describes a temporary variable."

	^true! !
!StTempVariable categoriesFor: #isTempVariable!public!testing! !

