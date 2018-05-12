"Filed out from Dolphin Smalltalk 7"!

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

	| info |
	info := exceptionRecord information.
	^super _descriptionArguments
		, {(info at: 1) == 0 ifTrue: ['Reading'] ifFalse: ['Writing']. (info at: 2) asExternalAddress}
	"7"
	"8"!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^'%4 %7 0x%8!!X!!, IP 0x%5!!X!! (%6)'! !
!GPFault categoriesFor: #_descriptionArguments!displaying!public! !
!GPFault categoriesFor: #_descriptionFormat!displaying!public! !

