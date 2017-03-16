"Filed out from Dolphin Smalltalk 7"!

NMHDR subclass: #NMKEYDOWN
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMKEYDOWN guid: (GUID fromString: '{87b4c628-026e-11d3-9fd7-00a0cc3e4a32}')!
NMKEYDOWN comment: 'NMKEYDOWN is an ExternalStructure class to represent the Win32 structures NMTVKEYDOWN, NMTCKEYDOWN and NMLVKEYDOWN, all of which have the same fields.
'!
!NMKEYDOWN categoriesForClass!External-Data-Structured-Win32! !
!NMKEYDOWN methodsFor!

flags
	"Answer the receiver's flags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #flags)!

wVKey
	"Answer the receiver's wVKey field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #wVKey)! !
!NMKEYDOWN categoriesFor: #flags!**compiled accessors**!public! !
!NMKEYDOWN categoriesFor: #wVKey!**compiled accessors**!public! !

!NMKEYDOWN class methodsFor!

defineFields
	"Define the fields of the Win32 NMKEYDOWN structure
		NMKEYDOWN compileDefinition
	"

	super defineFields.		"NMHDR fields"
	self defineField: #wVKey type: WORDField readOnly;
		defineField: #flags type: DWORDField readOnly! !
!NMKEYDOWN class categoriesFor: #defineFields!initializing!public! !

