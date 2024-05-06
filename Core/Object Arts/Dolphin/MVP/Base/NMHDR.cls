"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #NMHDR
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_code _OffsetOf_hwndFrom _OffsetOf_idFrom'
	poolDictionaries: 'CommCtrlConstants'
	classInstanceVariableNames: ''!

NMHDR guid: (GUID fromString: '{87b4c601-026e-11d3-9fd7-00a0cc3e4a32}')!

NMHDR addClassConstant: '_OffsetOf_code' value: 16r8!
NMHDR addClassConstant: '_OffsetOf_hwndFrom' value: 16r0!
NMHDR addClassConstant: '_OffsetOf_idFrom' value: 16r4!

NMHDR comment: 'NMHDR is a <Win32Structure> representing the NMHDR external Win32 API structure.'!

!NMHDR categoriesForClass!External-Data-Structured-Win32! !

!NMHDR methodsFor!

code
	"Answer the <Integer> value of the receiver's 'code' field."

	^bytes sdwordAtOffset: _OffsetOf_code!

hwndFrom
	"Answer the <Integer> value of the receiver's 'hwndFrom' field."

	^bytes dwordAtOffset: _OffsetOf_hwndFrom!

idFrom
	"Answer the <Integer> value of the receiver's 'idFrom' field."

	^bytes uintPtrAtOffset: _OffsetOf_idFrom!

itemHandle
	^self idFrom! !

!NMHDR categoriesForMethods!
code!**compiled accessors**!public! !
hwndFrom!**compiled accessors**!public! !
idFrom!**compiled accessors**!public! !
itemHandle!accessing!public! !
!

!NMHDR class methodsFor!

defineFields
	"Define the fields of the Win32 NMHDR structure

		NMHDR compileDefinition
	"

	self
		defineField: #hwndFrom type: DWORDField readOnly;
		defineField: #idFrom type: UINT_PTRField readOnly;
		defineField: #code type: SDWORDField readOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code)!

itemFromNMHDR: anExternalAddress
	^nil!

new
	"We only ever point to NMHDRs through an ExternalAddress. We
	never create those with embedded data."

	^self shouldNotImplement
! !

!NMHDR class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
itemFromNMHDR:!public! !
new!instance creation!public! !
!

