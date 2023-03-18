"Filed out from Dolphin Smalltalk"!

OS.NMHDR subclass: #'OS.NMTREEVIEWW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_NMTREEVIEWW_Size' -> 16r68.
		'_OffsetOf_action' -> 16rC.
		'_OffsetOf_itemNew' -> 16r38.
		'_OffsetOf_itemOld' -> 16r10.
		'_OffsetOf_ptDrag' -> 16r60
	}!
OS.NMTREEVIEWW guid: (Core.GUID fromString: '{87b4c62a-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.NMTREEVIEWW comment: ''!
!OS.NMTREEVIEWW categoriesForClass!External-Data-Structured-Win32! !
!OS.NMTREEVIEWW methodsFor!

action
	"Answer the <Integer> value of the receiver's 'action' field."

	^bytes uint32AtOffset: _OffsetOf_action!

itemHandle
	"Answer the 'handle' of the receiver's item."

	^self itemNew hItem!

itemNew
	"Answer the <TVITEMW> value of the receiver's 'itemNew' field."

	^TVITEMW fromAddress: bytes yourAddress + _OffsetOf_itemNew!

itemOld
	"Answer the <TVITEMW> value of the receiver's 'itemOld' field."

	^TVITEMW fromAddress: bytes yourAddress + _OffsetOf_itemOld!

ptDrag
	"Answer the <POINTL> value of the receiver's 'ptDrag' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptDrag! !
!OS.NMTREEVIEWW categoriesForMethods!
action!**compiled accessors**!public! !
itemHandle!accessing!public! !
itemNew!**compiled accessors**!public! !
itemOld!**compiled accessors**!public! !
ptDrag!**compiled accessors**!public! !
!

!OS.NMTREEVIEWW class methodsFor!

byteSize
	^_NMTREEVIEWW_Size!

defineFields
	"Define the structure template for Win32 NMTREEVIEW structure.
		self compileDefinition
	"

	super defineFields.
	self
		defineField: #action
			type: UInt32Field readOnly
			offset: 12;
		defineField: #itemOld
			type: (StructureField type: TVITEMW) beReadOnly
			offset: 16;
		defineField: #itemNew
			type: (StructureField type: TVITEMW) beReadOnly
			offset: 56;
		defineField: #ptDrag
			type: (StructureField type: POINTL) beReadOnly
			offset: 96!

getFieldNames
	^#(#hwndFrom #idFrom #code #action #itemOld #itemNew #ptDrag)! !
!OS.NMTREEVIEWW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

