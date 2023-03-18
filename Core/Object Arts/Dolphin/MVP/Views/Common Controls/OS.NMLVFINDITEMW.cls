"Filed out from Dolphin Smalltalk"!

OS.NMHDR subclass: #'OS.NMLVFINDITEMW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_NMLVFINDITEMW_Size' -> 16r28.
		'_OffsetOf_iStart' -> 16rC.
		'_OffsetOf_lvfi' -> 16r10
	}!
OS.NMLVFINDITEMW guid: (Core.GUID fromString: '{87b4c626-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.NMLVFINDITEMW comment: ''!
!OS.NMLVFINDITEMW categoriesForClass!External-Data-Structured-Win32! !
!OS.NMLVFINDITEMW methodsFor!

iStart
	"Answer the <Integer> value of the receiver's 'iStart' field."

	^bytes int32AtOffset: _OffsetOf_iStart!

lvfi
	"Answer the <LVFINDINFOW> value of the receiver's 'lvfi' field."

	^LVFINDINFOW fromAddress: bytes yourAddress + _OffsetOf_lvfi! !
!OS.NMLVFINDITEMW categoriesForMethods!
iStart!**compiled accessors**!public! !
lvfi!**compiled accessors**!public! !
!

!OS.NMLVFINDITEMW class methodsFor!

byteSize
	^_NMLVFINDITEMW_Size!

defineFields
	"Define the fields of the Win32 NMLVFINDITEM structure.
		self compileDefinition
	"

	super defineFields.
	self
		defineField: #iStart type: Int32Field readOnly;
		defineField: #lvfi type: (StructureField type: LVFINDINFOW) beReadOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #iStart #lvfi)! !
!OS.NMLVFINDITEMW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

