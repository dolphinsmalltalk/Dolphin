"Filed out from Dolphin Smalltalk 7"!

StSpecialVariable subclass: #StSelfVariable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StSelfVariable guid: (GUID fromString: '{55e9dda5-5cf0-449c-b4e4-c8d492c806af}')!
StSelfVariable comment: ''!
!StSelfVariable categoriesForClass!Kernel-Objects! !
!StSelfVariable methodsFor!

name
	^'self'!

valueClass
	"Answer the class of the variables value, if this is known, or nil if unknown."

	"The scope will be an StClassScope which is know's the method class."

	^scope methodClass! !
!StSelfVariable categoriesFor: #name!accessing!public! !
!StSelfVariable categoriesFor: #valueClass!accessing!public! !

