"Filed out from Dolphin Smalltalk 7"!

Error subclass: #CannotReturnError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
CannotReturnError guid: (GUID fromString: '{3986fbda-d1ac-42bd-81d9-060d7515a133}')!
CannotReturnError comment: ''!
!CannotReturnError categoriesForClass!Kernel-Exception Handling! !
!CannotReturnError methodsFor!

description
	^'Cannot return ' , self tag basicPrintString , ' to expired context or across Processes'! !
!CannotReturnError categoriesFor: #description!displaying!public! !

