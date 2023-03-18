"Filed out from Dolphin Smalltalk"!

OS.NMHDR
	subclass: #'OS.NMKEYDOWN'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_NMKEYDOWN_Size' -> 16r14. '_OffsetOf_flags' -> 16r10. '_OffsetOf_wVKey' -> 16rC }!
OS.NMKEYDOWN guid: (Core.GUID fromString: '{87b4c628-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.NMKEYDOWN comment: 'NMKEYDOWN is an ExternalStructure class to represent the Win32 structures NMTVKEYDOWN, NMTCKEYDOWN and NMLVKEYDOWN, all of which have the same fields.
'!
!OS.NMKEYDOWN categoriesForClass!External-Data-Structured-Win32! !
!OS.NMKEYDOWN methodsFor!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes uint32AtOffset: _OffsetOf_flags!

wVKey
	"Answer the <Integer> value of the receiver's 'wVKey' field."

	^bytes uint16AtOffset: _OffsetOf_wVKey! !
!OS.NMKEYDOWN categoriesForMethods!
flags!**compiled accessors**!public! !
wVKey!**compiled accessors**!public! !
!

!OS.NMKEYDOWN class methodsFor!

byteSize
	^_NMKEYDOWN_Size!

defineFields
	"Define the fields of the Win32 NMKEYDOWN structure
		NMKEYDOWN compileDefinition
	"

	super defineFields.	"NMHDR fields"
	self
		defineField: #wVKey type: UInt16Field readOnly;
		defineField: #flags type: UInt32Field readOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #wVKey #flags)! !
!OS.NMKEYDOWN class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

