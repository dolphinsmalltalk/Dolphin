"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.NMHDR'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.CommCtrlConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'_NMHDR_Size' -> 16rC.
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

	^bytes int32AtOffset: _OffsetOf_code!

hwndFrom
	"Answer the <Integer> value of the receiver's 'hwndFrom' field."

	^bytes uintPtrAtOffset: _OffsetOf_hwndFrom!

idFrom
	"Answer the <Integer> value of the receiver's 'idFrom' field."

	^bytes uintPtrAtOffset: _OffsetOf_idFrom!

itemHandle
	^self idFrom! !
!OS.NMHDR categoriesForMethods!
code!**compiled accessors**!public! !
hwndFrom!**compiled accessors**!public! !
idFrom!**compiled accessors**!public! !
itemHandle!accessing!public! !
!

!OS.NMHDR class methodsFor!

byteSize
	^_NMHDR_Size!

defineFields
	"Define the fields of the Win32 NMHDR structure

		NMHDR compileDefinition
	"

	self
		defineField: #hwndFrom type: UIntPtrField readOnly;
		defineField: #idFrom type: UIntPtrField readOnly;
		defineField: #code type: Int32Field readOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code)!

itemFromNMHDR: anExternalAddress
	^nil!

new
	"We only ever point to NMHDRs through an ExternalAddress. We
	never create those with embedded data."

	^self shouldNotImplement
! !
!OS.NMHDR class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
itemFromNMHDR:!public! !
new!instance creation!public! !
!

