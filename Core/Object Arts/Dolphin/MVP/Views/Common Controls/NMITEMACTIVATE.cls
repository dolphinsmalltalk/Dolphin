"Filed out from Dolphin Smalltalk"!

NMHDR subclass: #NMITEMACTIVATE
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_iItem _OffsetOf_iSubItem _OffsetOf_lParam _OffsetOf_ptAction _OffsetOf_uChanged _OffsetOf_uKeyFlags _OffsetOf_uNewState _OffsetOf_uOldState'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

NMITEMACTIVATE guid: (GUID fromString: '{78091823-3756-4d5a-816a-a5981291ae81}')!

NMITEMACTIVATE addClassConstant: '_OffsetOf_iItem' value: 16rC!
NMITEMACTIVATE addClassConstant: '_OffsetOf_iSubItem' value: 16r10!
NMITEMACTIVATE addClassConstant: '_OffsetOf_lParam' value: 16r28!
NMITEMACTIVATE addClassConstant: '_OffsetOf_ptAction' value: 16r20!
NMITEMACTIVATE addClassConstant: '_OffsetOf_uChanged' value: 16r1C!
NMITEMACTIVATE addClassConstant: '_OffsetOf_uKeyFlags' value: 16r2C!
NMITEMACTIVATE addClassConstant: '_OffsetOf_uNewState' value: 16r14!
NMITEMACTIVATE addClassConstant: '_OffsetOf_uOldState' value: 16r18!

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

!NMITEMACTIVATE categoriesForMethods!
iItem!**compiled accessors**!public! !
iSubItem!**compiled accessors**!public! !
position!accessing!public! !
ptAction!**compiled accessors**!public! !
uChanged!**compiled accessors**!public! !
uKeyFlags!**compiled accessors**!public! !
uNewState!**compiled accessors**!public! !
uOldState!**compiled accessors**!public! !
!

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

!NMITEMACTIVATE class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

