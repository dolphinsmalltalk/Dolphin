"Filed out from Dolphin Smalltalk"!

OS.Win32Structure
	subclass: #'OS.TVINSERTSTRUCTW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.TreeViewConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_hInsertAfter' -> 16r4.
			'_OffsetOf_hParent' -> 16r0.
			'_OffsetOf_item' -> 16r8.
			'_TVINSERTSTRUCTW_Size' -> 16r40
		}!
OS.TVINSERTSTRUCTW guid: (Core.GUID fromString: '{87b4c618-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.TVINSERTSTRUCTW comment: ''!
!OS.TVINSERTSTRUCTW categoriesForClass!External-Data-Structured-Win32! !
!OS.TVINSERTSTRUCTW methodsFor!

allCallbacks
	bytes
		int32AtOffset: ##(_OffsetOf_item + TVITEMW._OffsetOf_iImage) put: I_IMAGECALLBACK;
		int32AtOffset: ##(_OffsetOf_item + TVITEMW._OffsetOf_cChildren)
			put: OS.TreeViewConstants.I_CHILDRENCALLBACK;
		uint32AtOffset: ##(_OffsetOf_item + TVITEMW._OffsetOf_pszText) put: LPSTR_TEXTCALLBACK;
		uint32AtOffset: ##(_OffsetOf_item + TVITEMW._OffsetOf_mask)
			put: ((bytes uint32AtOffset: ##(_OffsetOf_item + TVITEMW._OffsetOf_mask)) bitOr: ##(TVIF_TEXT | TVIF_CHILDREN | TVIF_IMAGE))!

hInsertAfter: anInteger
	"Set the receiver's 'hInsertAfter' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_hInsertAfter put: anInteger!

hParent: anInteger
	"Set the receiver's 'hParent' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_hParent put: anInteger!

item
	"Answer the <TVITEMEXW> value of the receiver's 'item' field."

	^TVITEMEXW fromAddress: bytes yourAddress + _OffsetOf_item!

item: aTVITEMEXW
	"Set the receiver's 'item' field to the value of the argument, aTVITEMEXW"

	aTVITEMEXW
		replaceBytesOf: bytes
		from: ##(_OffsetOf_item + 1)
		to: ##(_OffsetOf_item + TVITEMEXW._TVITEMEXW_Size)
		startingAt: 1! !
!OS.TVINSERTSTRUCTW categoriesForMethods!
allCallbacks!initializing!public! !
hInsertAfter:!**compiled accessors**!public! !
hParent:!**compiled accessors**!public! !
item!**compiled accessors**!public! !
item:!**compiled accessors**!public! !
!

!OS.TVINSERTSTRUCTW class methodsFor!

byteSize
	^_TVINSERTSTRUCTW_Size!

defineFields
	"Define the layout of the Win32 TVINSERTSTRUCT structure.
		self compileDefinition
	"

	self
		defineField: #hParent
			type: UInt32Field writeOnly
			offset: 0;
		defineField: #hInsertAfter
			type: UInt32Field writeOnly
			offset: 4;
		defineField: #item
			type: (StructureField type: TVITEMEXW)
			offset: 8	"read/write so can get pointer to embedded TVITEM"!

getFieldNames
	^#(#hParent #hInsertAfter #item)! !
!OS.TVINSERTSTRUCTW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

