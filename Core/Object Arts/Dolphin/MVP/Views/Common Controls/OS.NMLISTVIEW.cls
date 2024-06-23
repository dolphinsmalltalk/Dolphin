"Filed out from Dolphin Smalltalk"!

OS.NMHDR
	subclass: #'OS.NMLISTVIEW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_NMLISTVIEW_Size' -> 16r2C.
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

	^bytes int32AtOffset: _OffsetOf_iItem!

iSubItem
	"Answer the <Integer> value of the receiver's 'iSubItem' field."

	^bytes int32AtOffset: _OffsetOf_iSubItem!

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

	^bytes uint32AtOffset: _OffsetOf_uChanged!

uNewState
	"Answer the <Integer> value of the receiver's 'uNewState' field."

	^bytes uint32AtOffset: _OffsetOf_uNewState!

uOldState
	"Answer the <Integer> value of the receiver's 'uOldState' field."

	^bytes uint32AtOffset: _OffsetOf_uOldState! !

!OS.NMLISTVIEW categoriesForMethods!
iItem!**compiled accessors**!public! !
iSubItem!**compiled accessors**!public! !
itemHandle!accessing!public! !
lParam!**compiled accessors**!public! !
ptAction!**compiled accessors**!public! !
uChanged!**compiled accessors**!public! !
uNewState!**compiled accessors**!public! !
uOldState!**compiled accessors**!public! !
!

!OS.NMLISTVIEW class methodsFor!

byteSize
	^_NMLISTVIEW_Size!

defineFields
	"Define the structure template for Win32 NMLISTVIEW structure.
		NMLISTVIEW compileDefinition
	"

	super defineFields.
	self
		defineField: #iItem type: Int32Field readOnly;
		defineField: #iSubItem type: Int32Field readOnly;
		defineField: #uNewState type: UInt32Field readOnly;
		defineField: #uOldState type: UInt32Field readOnly;
		defineField: #uChanged type: UInt32Field readOnly;
		defineField: #ptAction type: (StructureField type: POINTL) beReadOnly;
		defineField: #lParam type: UIntPtrField readOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #iItem #iSubItem #uNewState #uOldState #uChanged #ptAction #lParam)! !

!OS.NMLISTVIEW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

