"Filed out from Dolphin Smalltalk"!

Error subclass: #CannotReturnError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CannotReturnError guid: (GUID fromString: '{3986fbda-d1ac-42bd-81d9-060d7515a133}')!
CannotReturnError comment: ''!
!CannotReturnError categoriesForClass!Kernel-Exception Handling! !
!CannotReturnError methodsFor!

description
	^'Cannot return ' , self tag basicPrintString , ' to expired context or across Processes'! !
!CannotReturnError categoriesForMethods!
description!displaying!public! !
!

