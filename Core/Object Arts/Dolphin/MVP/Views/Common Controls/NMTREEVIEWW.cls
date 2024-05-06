"Filed out from Dolphin Smalltalk"!

NMHDR subclass: #NMTREEVIEWW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_action _OffsetOf_itemNew _OffsetOf_itemOld _OffsetOf_ptDrag'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

NMTREEVIEWW guid: (GUID fromString: '{87b4c62a-026e-11d3-9fd7-00a0cc3e4a32}')!

NMTREEVIEWW addClassConstant: '_OffsetOf_action' value: 16rC!
NMTREEVIEWW addClassConstant: '_OffsetOf_itemNew' value: 16r38!
NMTREEVIEWW addClassConstant: '_OffsetOf_itemOld' value: 16r10!
NMTREEVIEWW addClassConstant: '_OffsetOf_ptDrag' value: 16r60!

NMTREEVIEWW comment: ''!

!NMTREEVIEWW categoriesForClass!External-Data-Structured-Win32! !

!NMTREEVIEWW methodsFor!

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

!NMTREEVIEWW categoriesForMethods!
action!**compiled accessors**!public! !
itemHandle!accessing!public! !
itemNew!**compiled accessors**!public! !
itemOld!**compiled accessors**!public! !
ptDrag!**compiled accessors**!public! !
!

!NMTREEVIEWW class methodsFor!

defineFields
	"Define the structure template for Win32 NMTREEVIEW structure.
		self compileDefinition
	"

	super defineFields.
	self
		defineField: #action type: DWORDField readOnly offset: 12;
		defineField: #itemOld type: (StructureField type: TVITEMW) beReadOnly offset: 16;
		defineField: #itemNew type: (StructureField type: TVITEMW) beReadOnly offset: 56;
		defineField: #ptDrag type: (StructureField type: POINTL) beReadOnly offset: 96!

getFieldNames
	^#(#hwndFrom #idFrom #code #action #itemOld #itemNew #ptDrag)! !

!NMTREEVIEWW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

