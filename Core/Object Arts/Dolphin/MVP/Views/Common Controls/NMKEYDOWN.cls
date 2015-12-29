"Filed out from Dolphin Smalltalk X6.1"!

NMHDR subclass: #NMKEYDOWN
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMKEYDOWN guid: (GUID fromString: '{87B4C628-026E-11D3-9FD7-00A0CC3E4A32}')!
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

