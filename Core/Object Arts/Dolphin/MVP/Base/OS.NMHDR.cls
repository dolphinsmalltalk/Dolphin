"Filed out from Dolphin Smalltalk 7"!

OS.Win32Structure subclass: #'OS.NMHDR'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.CommCtrlConstants})
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_code' -> 16r8.
		'_OffsetOf_hwndFrom' -> 16r0.
		'_OffsetOf_idFrom' -> 16r4
	}!
OS.NMHDR guid: (Core.GUID fromString: '{87b4c601-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.NMHDR comment: 'NMHDR is a <Win32Structure> representing the NMHDR external Win32 API structure.'!
!OS.NMHDR categoriesForClass!External-Data-Structured-Win32! !
!OS.NMHDR methodsFor!

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
!OS.NMHDR categoriesFor: #code!**compiled accessors**!public! !
!OS.NMHDR categoriesFor: #hwndFrom!**compiled accessors**!public! !
!OS.NMHDR categoriesFor: #idFrom!**compiled accessors**!public! !
!OS.NMHDR categoriesFor: #itemHandle!accessing!public! !

!OS.NMHDR class methodsFor!

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
!OS.NMHDR class categoriesFor: #defineFields!public!template definition! !
!OS.NMHDR class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!OS.NMHDR class categoriesFor: #itemFromNMHDR:!public! !
!OS.NMHDR class categoriesFor: #new!instance creation!public! !

