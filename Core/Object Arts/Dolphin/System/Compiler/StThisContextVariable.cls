"Filed out from Dolphin Smalltalk 7"!

StSpecialVariable subclass: #StThisContextVariable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StThisContextVariable guid: (GUID fromString: '{dbebe810-ee05-4346-aa77-6131cf03eca2}')!
StThisContextVariable comment: ''!
!StThisContextVariable categoriesForClass!Kernel-Objects! !
!StThisContextVariable methodsFor!

name
	^'thisContext'!

valueClass
	"Answer the class of the variables value, if this is known, or nil if unknown."

	^Integer! !
!StThisContextVariable categoriesFor: #name!accessing!public! !
!StThisContextVariable categoriesFor: #valueClass!accessing!public! !

