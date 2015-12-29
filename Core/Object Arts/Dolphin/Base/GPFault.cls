"Filed out from Dolphin Smalltalk X6"!

Win32Fault subclass: #GPFault
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GPFault guid: (GUID fromString: '{87B4C567-026E-11D3-9FD7-00A0CC3E4A32}')!
GPFault comment: ''!
!GPFault categoriesForClass!System-Exception Handling! !
!GPFault methodsFor!

_descriptionArguments
	"Answer the arguments to be substitued into the receiver's Win32 description format String."

	| info |
	info := exceptionRecord information.
	^super _descriptionArguments 
		, (Array with: ((info at: 1) == 0 ifTrue: ['Reading'] ifFalse: ['Writing'])
				with: (info at: 2) asExternalAddress)
	"7"
	"8"!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^'%4 %7 0x%8!!X!!, IP 0x%5!!X!! (%6)'! !
!GPFault categoriesFor: #_descriptionArguments!displaying!public! !
!GPFault categoriesFor: #_descriptionFormat!displaying!public! !

