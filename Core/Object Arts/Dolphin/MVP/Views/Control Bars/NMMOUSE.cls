"Filed out from Dolphin Smalltalk"!

NMHDR subclass: #NMMOUSE
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwHitInfo _OffsetOf_dwItemData _OffsetOf_dwItemSpec _OffsetOf_pt'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMMOUSE guid: (GUID fromString: '{e2a1ec3f-20b2-49cc-b90f-80f002a28204}')!
NMMOUSE addClassConstant: '_OffsetOf_dwHitInfo' value: 16r1C!
NMMOUSE addClassConstant: '_OffsetOf_dwItemData' value: 16r10!
NMMOUSE addClassConstant: '_OffsetOf_dwItemSpec' value: 16rC!
NMMOUSE addClassConstant: '_OffsetOf_pt' value: 16r14!
NMMOUSE comment: 'NMMOUSE is the class of <ExternalStructure> which represent the Windows Common Control structure of the same name.

NMMOUSE accompanies certain notifications that are sent by a control bars (e.g. toolbars, statusbars) when a mouse action occurs such as a click.
'!
!NMMOUSE categoriesForClass!External-Data-Structured-Win32! !
!NMMOUSE methodsFor!

dwHitInfo
	"Answer the <Integer> value of the receiver's 'dwHitInfo' field."

	^bytes dwordAtOffset: _OffsetOf_dwHitInfo!

dwItemData
	"Answer the <Integer> value of the receiver's 'dwItemData' field."

	^bytes dwordAtOffset: _OffsetOf_dwItemData!

dwItemSpec
	"Answer the <Integer> value of the receiver's 'dwItemSpec' field."

	^bytes dwordAtOffset: _OffsetOf_dwItemSpec!

iItem
	"Answer the item index (appropriate when originating from a control whose items
	are externally identified by integer keys)."

	^bytes sdwordAtOffset: 12!

position
	^self pt asPoint!

pt
	"Answer the <POINTL> value of the receiver's 'pt' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_pt! !
!NMMOUSE categoriesForMethods!
dwHitInfo!**compiled accessors**!public! !
dwItemData!**compiled accessors**!public! !
dwItemSpec!**compiled accessors**!public! !
iItem!accessing!public! !
position!accessing!public! !
pt!**compiled accessors**!public! !
!

!NMMOUSE class methodsFor!

defineFields
	"Define the structure template for Win32 NMMOUSE structure.
		self compileDefinition
	"

	super defineFields.
	self 
		defineField: #dwItemSpec type: DWORDField readOnly;
		defineField: #dwItemData type: DWORDField readOnly;
		defineField: #pt type: (StructureField type: POINTL) beReadOnly;
		defineField: #dwHitInfo type: DWORDField readOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #dwItemSpec #dwItemData #pt #dwHitInfo)! !
!NMMOUSE class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

