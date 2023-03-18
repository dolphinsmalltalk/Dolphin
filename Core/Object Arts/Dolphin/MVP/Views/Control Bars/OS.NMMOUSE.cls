"Filed out from Dolphin Smalltalk"!

OS.NMHDR subclass: #'OS.NMMOUSE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_NMMOUSE_Size' -> 16r20.
		'_OffsetOf_dwHitInfo' -> 16r1C.
		'_OffsetOf_dwItemData' -> 16r10.
		'_OffsetOf_dwItemSpec' -> 16rC.
		'_OffsetOf_pt' -> 16r14
	}!
OS.NMMOUSE guid: (Core.GUID fromString: '{e2a1ec3f-20b2-49cc-b90f-80f002a28204}')!
OS.NMMOUSE comment: 'NMMOUSE is the class of <ExternalStructure> which represent the Windows Common Control structure of the same name.

NMMOUSE accompanies certain notifications that are sent by a control bars (e.g. toolbars, statusbars) when a mouse action occurs such as a click.
'!
!OS.NMMOUSE categoriesForClass!External-Data-Structured-Win32! !
!OS.NMMOUSE methodsFor!

dwHitInfo
	"Answer the <Integer> value of the receiver's 'dwHitInfo' field."

	^bytes uint32AtOffset: _OffsetOf_dwHitInfo!

dwItemData
	"Answer the <Integer> value of the receiver's 'dwItemData' field."

	^bytes uint32AtOffset: _OffsetOf_dwItemData!

dwItemSpec
	"Answer the <Integer> value of the receiver's 'dwItemSpec' field."

	^bytes uint32AtOffset: _OffsetOf_dwItemSpec!

iItem
	"Answer the item index (appropriate when originating from a control whose items
	are externally identified by integer keys)."

	^bytes int32AtOffset: 12!

position
	^self pt asPoint!

pt
	"Answer the <POINTL> value of the receiver's 'pt' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_pt! !
!OS.NMMOUSE categoriesForMethods!
dwHitInfo!**compiled accessors**!public! !
dwItemData!**compiled accessors**!public! !
dwItemSpec!**compiled accessors**!public! !
iItem!accessing!public! !
position!accessing!public! !
pt!**compiled accessors**!public! !
!

!OS.NMMOUSE class methodsFor!

byteSize
	^_NMMOUSE_Size!

defineFields
	"Define the structure template for Win32 NMMOUSE structure.
		self compileDefinition
	"

	super defineFields.
	self
		defineField: #dwItemSpec type: UInt32Field readOnly;
		defineField: #dwItemData type: UInt32Field readOnly;
		defineField: #pt type: (StructureField type: POINTL) beReadOnly;
		defineField: #dwHitInfo type: UInt32Field readOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #dwItemSpec #dwItemData #pt #dwHitInfo)! !
!OS.NMMOUSE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

