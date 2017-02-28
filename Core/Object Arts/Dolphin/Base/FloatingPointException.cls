"Filed out from Dolphin Smalltalk 7"!

ArithmeticError subclass: #FloatingPointException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FloatingPointException guid: (GUID fromString: '{87B4C562-026E-11D3-9FD7-00A0CC3E4A32}')!
FloatingPointException comment: ''!
!FloatingPointException categoriesForClass!Kernel-Exception Handling! !
!FloatingPointException methodsFor!

_descriptionArguments
	"Answer the arguments to be subsituted into the receiver's description 
	format string."

	| record |
	record := self _ieeeRecord.
	^super _descriptionArguments , (Array with: record causeDescription with: record operationName)!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^'Floating point error: %3 in %4'!

_ieeeRecord
	"Private - Answer the IEEE exception record associated with the receiver."

	^self tag!

isOverflow
	"Answer whether receiver represents a floating point overflow error."

	^self tag isOverflow
!

isUnderflow
	"Answer whether receiver represents a floating point underflow error."

	^self tag isUnderflow
! !
!FloatingPointException categoriesFor: #_descriptionArguments!displaying!public! !
!FloatingPointException categoriesFor: #_descriptionFormat!displaying!public! !
!FloatingPointException categoriesFor: #_ieeeRecord!accessing!private! !
!FloatingPointException categoriesFor: #isOverflow!public!testing! !
!FloatingPointException categoriesFor: #isUnderflow!public!testing! !

