"Filed out from Dolphin Smalltalk 7"!

QWORD subclass: #ULARGE_INTEGER
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ULARGE_INTEGER guid: (GUID fromString: '{87b4c631-026e-11d3-9fd7-00a0cc3e4a32}')!
ULARGE_INTEGER comment: '<ULARGE_INTEGER> is an <ExternalStructure> class to wrap the Win32 structure of the same name.

ULARGE_INTEGER is used to represent unsigned 64-bit integers in conjunction with Win32 APIs. 

The range of integer values that can be represented by instances of this class is defined by the interval:
	0 to: (2**64)-1
'!
!ULARGE_INTEGER categoriesForClass!External-Data-Structured-Win32! !
!ULARGE_INTEGER methodsFor!

value
	"Answer the receiver's value field as a Smalltalk object."

	^bytes qwordAtOffset: 0!

value: anObject 
	"Set the receiver's value field to the value of anObject."

	bytes qwordAtOffset: 0 put: anObject! !
!ULARGE_INTEGER categoriesFor: #value!**compiled accessors**!public! !
!ULARGE_INTEGER categoriesFor: #value:!**compiled accessors**!public! !

