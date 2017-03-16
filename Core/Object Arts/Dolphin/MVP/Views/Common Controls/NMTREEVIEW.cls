"Filed out from Dolphin Smalltalk 7"!

NMHDR subclass: #NMTREEVIEW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMTREEVIEW guid: (GUID fromString: '{87b4c62a-026e-11d3-9fd7-00a0cc3e4a32}')!
NMTREEVIEW comment: ''!
!NMTREEVIEW categoriesForClass!External-Data-Structured-Win32! !
!NMTREEVIEW methodsFor!

action
	"Answer the receiver's action field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #action)!

itemHandle
	"Answer the 'handle' of the receiver's item."

	^self itemNew hItem!

itemNew
	"Answer the receiver's itemNew field as a Smalltalk object."

	^TVITEM fromAddress: bytes yourAddress + ##(self offsetOf: #itemNew)!

itemOld
	"Answer the receiver's itemOld field as a Smalltalk object."

	^TVITEM fromAddress: bytes yourAddress + ##(self offsetOf: #itemOld)!

ptDrag
	"Answer the receiver's ptDrag field as a Smalltalk object."

	^POINTL fromAddress: bytes yourAddress + ##(self offsetOf: #ptDrag)! !
!NMTREEVIEW categoriesFor: #action!**compiled accessors**!public! !
!NMTREEVIEW categoriesFor: #itemHandle!accessing!public! !
!NMTREEVIEW categoriesFor: #itemNew!**compiled accessors**!public! !
!NMTREEVIEW categoriesFor: #itemOld!**compiled accessors**!public! !
!NMTREEVIEW categoriesFor: #ptDrag!**compiled accessors**!public! !

!NMTREEVIEW class methodsFor!

defineFields
	"Define the structure template for Win32 NMTREEVIEW structure.
		NMTREEVIEW compileDefinition
	"

	super defineFields.
	self 
		defineField: #action type: DWORDField readOnly;
		defineField: #itemOld type: (StructureField type: TVITEM) beReadOnly;
		defineField: #itemNew type: (StructureField type: TVITEM) beReadOnly;
		defineField: #ptDrag type: (StructureField type: POINTL) beReadOnly! !
!NMTREEVIEW class categoriesFor: #defineFields!initializing!public! !

