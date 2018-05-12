"Filed out from Dolphin Smalltalk 7"!

NMHDR subclass: #NMTREEVIEWW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMTREEVIEWW guid: (GUID fromString: '{87b4c62a-026e-11d3-9fd7-00a0cc3e4a32}')!
NMTREEVIEWW comment: ''!
!NMTREEVIEWW categoriesForClass!External-Data-Structured-Win32! !
!NMTREEVIEWW methodsFor!

action
	"Answer the <Integer> value of the receiver's 'action' field."

	^bytes dwordAtOffset: ##(self offsetOf: #action)!

itemHandle
	"Answer the 'handle' of the receiver's item."

	^self itemNew hItem!

itemNew
	"Answer the <TVITEM> value of the receiver's 'itemNew' field."

	^TVITEMW fromAddress: bytes yourAddress + ##(self offsetOf: #itemNew)!

itemOld
	"Answer the <TVITEM> value of the receiver's 'itemOld' field."

	^TVITEMW fromAddress: bytes yourAddress + ##(self offsetOf: #itemOld)!

ptDrag
	"Answer the <POINTL> value of the receiver's 'ptDrag' field."

	^POINTL fromAddress: bytes yourAddress + ##(self offsetOf: #ptDrag)! !
!NMTREEVIEWW categoriesFor: #action!**compiled accessors**!public! !
!NMTREEVIEWW categoriesFor: #itemHandle!accessing!public! !
!NMTREEVIEWW categoriesFor: #itemNew!**compiled accessors**!public! !
!NMTREEVIEWW categoriesFor: #itemOld!**compiled accessors**!public! !
!NMTREEVIEWW categoriesFor: #ptDrag!**compiled accessors**!public! !

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
		defineField: #ptDrag type: (StructureField type: POINTL) beReadOnly offset: 96! !
!NMTREEVIEWW class categoriesFor: #defineFields!initializing!public! !

