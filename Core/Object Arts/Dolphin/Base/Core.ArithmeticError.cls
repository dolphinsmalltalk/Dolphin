"Filed out from Dolphin Smalltalk 7"!

Error subclass: #ArithmeticError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ArithmeticError guid: (GUID fromString: '{87b4c557-026e-11d3-9fd7-00a0cc3e4a32}')!
ArithmeticError comment: ''!
!ArithmeticError categoriesForClass!Kernel-Exception Handling! !
!ArithmeticError methodsFor!

isResumable
	"Answer whether the receiver represents a resumable error. Most arithmetic errors are resumable."

	^true! !
!ArithmeticError categoriesFor: #isResumable!public!testing! !

