"Filed out from Dolphin Smalltalk"!

NMHDR subclass: #NMLISTVIEW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_iItem _OffsetOf_iSubItem _OffsetOf_lParam _OffsetOf_ptAction _OffsetOf_uChanged _OffsetOf_uNewState _OffsetOf_uOldState'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMLISTVIEW guid: (GUID fromString: '{87b4c624-026e-11d3-9fd7-00a0cc3e4a32}')!
NMLISTVIEW addClassConstant: '_OffsetOf_iItem' value: 16rC!
NMLISTVIEW addClassConstant: '_OffsetOf_iSubItem' value: 16r10!
NMLISTVIEW addClassConstant: '_OffsetOf_lParam' value: 16r28!
NMLISTVIEW addClassConstant: '_OffsetOf_ptAction' value: 16r20!
NMLISTVIEW addClassConstant: '_OffsetOf_uChanged' value: 16r1C!
NMLISTVIEW addClassConstant: '_OffsetOf_uNewState' value: 16r14!
NMLISTVIEW addClassConstant: '_OffsetOf_uOldState' value: 16r18!
NMLISTVIEW comment: ''!
!NMLISTVIEW categoriesForClass!External-Data-Structured-Win32! !
!NMLISTVIEW methodsFor!

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
!NMLISTVIEW categoriesForMethods!
iItem!**compiled accessors**!public! !
iSubItem!**compiled accessors**!public! !
itemHandle!accessing!public! !
lParam!**compiled accessors**!public! !
ptAction!**compiled accessors**!public! !
uChanged!**compiled accessors**!public! !
uNewState!**compiled accessors**!public! !
uOldState!**compiled accessors**!public! !
!

!NMLISTVIEW class methodsFor!

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
!NMLISTVIEW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

