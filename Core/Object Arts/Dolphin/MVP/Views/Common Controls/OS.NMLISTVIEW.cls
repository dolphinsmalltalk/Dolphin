"Filed out from Dolphin Smalltalk 7"!

OS.NMHDR subclass: #'OS.NMLISTVIEW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_iItem' -> 16rC.
		'_OffsetOf_iSubItem' -> 16r10.
		'_OffsetOf_lParam' -> 16r28.
		'_OffsetOf_ptAction' -> 16r20.
		'_OffsetOf_uChanged' -> 16r1C.
		'_OffsetOf_uNewState' -> 16r14.
		'_OffsetOf_uOldState' -> 16r18
	}!
OS.NMLISTVIEW guid: (Core.GUID fromString: '{87b4c624-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.NMLISTVIEW comment: ''!
!OS.NMLISTVIEW categoriesForClass!External-Data-Structured-Win32! !
!OS.NMLISTVIEW methodsFor!

iItem
	"Answer the <Integer> value of the receiver's 'iItem' field."

	^bytes sdwordAtOffset: _OffsetOf_iItem!

iSubItem
	"Answer the <Integer> value of the receiver's 'iSubItem' field."

	^bytes sdwordAtOffset: _OffsetOf_iSubItem!

itemHandle
	"Answer the 'handle' of the receiver's item."

	^self iItem + 1!

lParam
	"Answer the <Integer> value of the receiver's 'lParam' field."

	^bytes uintPtrAtOffset: _OffsetOf_lParam!

ptAction
	"Answer the <POINTL> value of the receiver's 'ptAction' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptAction!

uChanged
	"Answer the <Integer> value of the receiver's 'uChanged' field."

	^bytes dwordAtOffset: _OffsetOf_uChanged!

uNewState
	"Answer the <Integer> value of the receiver's 'uNewState' field."

	^bytes dwordAtOffset: _OffsetOf_uNewState!

uOldState
	"Answer the <Integer> value of the receiver's 'uOldState' field."

	^bytes dwordAtOffset: _OffsetOf_uOldState! !
!OS.NMLISTVIEW categoriesFor: #iItem!**compiled accessors**!public! !
!OS.NMLISTVIEW categoriesFor: #iSubItem!**compiled accessors**!public! !
!OS.NMLISTVIEW categoriesFor: #itemHandle!accessing!public! !
!OS.NMLISTVIEW categoriesFor: #lParam!**compiled accessors**!public! !
!OS.NMLISTVIEW categoriesFor: #ptAction!**compiled accessors**!public! !
!OS.NMLISTVIEW categoriesFor: #uChanged!**compiled accessors**!public! !
!OS.NMLISTVIEW categoriesFor: #uNewState!**compiled accessors**!public! !
!OS.NMLISTVIEW categoriesFor: #uOldState!**compiled accessors**!public! !

!OS.NMLISTVIEW class methodsFor!

defineFields
	"Define the structure template for Win32 NMLISTVIEW structure.
		NMLISTVIEW compileDefinition
	"

	super defineFields.
	self
		defineField: #iItem type: SDWORDField readOnly;
		defineField: #iSubItem type: SDWORDField readOnly;
		defineField: #uNewState type: DWORDField readOnly;
		defineField: #uOldState type: DWORDField readOnly;
		defineField: #uChanged type: DWORDField readOnly;
		defineField: #ptAction type: (StructureField type: POINTL) beReadOnly;
		defineField: #lParam type: UINT_PTRField readOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #iItem #iSubItem #uNewState #uOldState #uChanged #ptAction #lParam)! !
!OS.NMLISTVIEW class categoriesFor: #defineFields!public!template definition! !
!OS.NMLISTVIEW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

