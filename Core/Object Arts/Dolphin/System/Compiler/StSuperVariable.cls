"Filed out from Dolphin Smalltalk 7"!

StSpecialVariable subclass: #StSuperVariable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StSuperVariable guid: (GUID fromString: '{23a2ad6e-f898-4e60-813c-54d499b62609}')!
StSuperVariable comment: ''!
!StSuperVariable categoriesForClass!Kernel-Objects! !
!StSuperVariable methodsFor!

name
	^'super'!

valueClass
	"Answer the class of the variables value, if this is known, or nil if unknown."

	^scope methodClass superclass! !
!StSuperVariable categoriesFor: #name!accessing!public! !
!StSuperVariable categoriesFor: #valueClass!accessing!public! !

