"Filed out from Dolphin Smalltalk 7"!

NMHDR subclass: #NMITEMACTIVATE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_iItem' -> 16rC.
		'_OffsetOf_iSubItem' -> 16r10.
		'_OffsetOf_lParam' -> 16r28.
		'_OffsetOf_ptAction' -> 16r20.
		'_OffsetOf_uChanged' -> 16r1C.
		'_OffsetOf_uKeyFlags' -> 16r2C.
		'_OffsetOf_uNewState' -> 16r14.
		'_OffsetOf_uOldState' -> 16r18
	}!
NMITEMACTIVATE guid: (GUID fromString: '{78091823-3756-4d5a-816a-a5981291ae81}')!
NMITEMACTIVATE comment: ''!
!NMITEMACTIVATE categoriesForClass!External-Data-Structured-Win32! !
!NMITEMACTIVATE methodsFor!

iItem
	"Answer the <Integer> value of the receiver's 'iItem' field."

	^bytes sdwordAtOffset: _OffsetOf_iItem!

iSubItem
	"Answer the <Integer> value of the receiver's 'iSubItem' field."

	^bytes sdwordAtOffset: _OffsetOf_iSubItem!

position
	^self ptAction asPoint!

ptAction
	"Answer the <POINTL> value of the receiver's 'ptAction' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptAction!

uChanged
	"Answer the <Integer> value of the receiver's 'uChanged' field."

	^bytes dwordAtOffset: _OffsetOf_uChanged!

uKeyFlags
	"Answer the <Integer> value of the receiver's 'uKeyFlags' field."

	^bytes dwordAtOffset: _OffsetOf_uKeyFlags!

uNewState
	"Answer the <Integer> value of the receiver's 'uNewState' field."

	^bytes dwordAtOffset: _OffsetOf_uNewState!

uOldState
	"Answer the <Integer> value of the receiver's 'uOldState' field."

	^bytes dwordAtOffset: _OffsetOf_uOldState! !
!NMITEMACTIVATE categoriesFor: #iItem!**compiled accessors**!public! !
!NMITEMACTIVATE categoriesFor: #iSubItem!**compiled accessors**!public! !
!NMITEMACTIVATE categoriesFor: #position!accessing!public! !
!NMITEMACTIVATE categoriesFor: #ptAction!**compiled accessors**!public! !
!NMITEMACTIVATE categoriesFor: #uChanged!**compiled accessors**!public! !
!NMITEMACTIVATE categoriesFor: #uKeyFlags!**compiled accessors**!public! !
!NMITEMACTIVATE categoriesFor: #uNewState!**compiled accessors**!public! !
!NMITEMACTIVATE categoriesFor: #uOldState!**compiled accessors**!public! !

!NMITEMACTIVATE class methodsFor!

defineFields
	"
		self compileDefinition

		typedef struct tagNMITEMACTIVATE{ 
			NMHDR hdr; 
			int iItem; 
			int iSubItem; 
			UINT uNewState; 
			UINT uOldState; 
			UINT uChanged; 
			POINT ptAction; 
			LPARAM lParam; 
			UINT uKeyFlags; 
		} NMITEMACTIVATE, *LPNMITEMACTIVATE; "

	super defineFields.
	self
		defineField: #iItem type: SDWORDField readOnly;
		defineField: #iSubItem type: SDWORDField readOnly;
		defineField: #uNewState type: DWORDField readOnly;
		defineField: #uOldState type: DWORDField readOnly;
		defineField: #uChanged type: DWORDField readOnly;
		defineField: #ptAction type: (StructureField type: POINTL) beReadOnly;
		defineField: #lParam type: INT_PTRField filler;
		defineField: #uKeyFlags type: DWORDField readOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #iItem #iSubItem #uNewState #uOldState #uChanged #ptAction #uKeyFlags)! !
!NMITEMACTIVATE class categoriesFor: #defineFields!public!template definition! !
!NMITEMACTIVATE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

