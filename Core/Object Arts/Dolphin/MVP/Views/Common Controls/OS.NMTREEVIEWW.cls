"Filed out from Dolphin Smalltalk 7"!

OS.NMHDR subclass: #'OS.NMTREEVIEWW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
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

	^bytes dwordAtOffset: _OffsetOf_action!

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
!OS.NMTREEVIEWW categoriesFor: #action!**compiled accessors**!public! !
!OS.NMTREEVIEWW categoriesFor: #itemHandle!accessing!public! !
!OS.NMTREEVIEWW categoriesFor: #itemNew!**compiled accessors**!public! !
!OS.NMTREEVIEWW categoriesFor: #itemOld!**compiled accessors**!public! !
!OS.NMTREEVIEWW categoriesFor: #ptDrag!**compiled accessors**!public! !

!OS.NMTREEVIEWW class methodsFor!

defineFields
	"Define the structure template for Win32 NMTREEVIEW structure.
		self compileDefinition
	"

	super defineFields.
	self
		defineField: #action
			type: DWORDField readOnly
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
!OS.NMTREEVIEWW class categoriesFor: #defineFields!public!template definition! !
!OS.NMTREEVIEWW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

