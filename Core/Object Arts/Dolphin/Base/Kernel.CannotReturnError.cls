"Filed out from Dolphin Smalltalk"!

Core.Error
	subclass: #'Kernel.CannotReturnError'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.CannotReturnError guid: (Core.GUID fromString: '{3986fbda-d1ac-42bd-81d9-060d7515a133}')!
Kernel.CannotReturnError comment: ''!
!Kernel.CannotReturnError categoriesForClass!Kernel-Exception Handling! !
!Kernel.CannotReturnError methodsFor!

description
	^'Cannot return ' , self tag basicPrintString , ' to expired context or across Processes'! !
!Kernel.CannotReturnError categoriesForMethods!
description!displaying!public! !
!

