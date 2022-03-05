"Filed out from Dolphin Smalltalk"!

Win32Fault subclass: #GPFault
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GPFault guid: (GUID fromString: '{87b4c567-026e-11d3-9fd7-00a0cc3e4a32}')!
GPFault comment: ''!
!GPFault categoriesForClass!System-Exception Handling! !
!GPFault methodsFor!

_descriptionArguments
	"Answer the arguments to be substitued into the receiver's Win32 description format String."

	^super _descriptionArguments
		, {self isReading ifTrue: ['Reading'] ifFalse: ['Writing']. self inaccessibleAddress}!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^'%4 %7 0x%8!!X!!, IP 0x%5!!X!! (%6)'!

inaccessibleAddress
	"Answer the address that an attempt was being made to access when the fault occurred because it cannot be read/written."

	^(exceptionRecord information at: 2) asExternalAddress!

isReading
	"Answer whether the fault occurred attempting to read from memory (as opposed to writing)."

	^(exceptionRecord information at: 1) == 0! !
!GPFault categoriesForMethods!
_descriptionArguments!displaying!public! !
_descriptionFormat!displaying!public! !
inaccessibleAddress!accessing!public! !
isReading!accessing!public! !
!

