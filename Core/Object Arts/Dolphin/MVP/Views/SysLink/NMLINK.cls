"Filed out from Dolphin Smalltalk"!

NMHDR subclass: #NMLINK
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_item'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

NMLINK guid: (GUID fromString: '{7caa2dd6-a6d4-493f-bdd4-39ef71f66221}')!

NMLINK addClassConstant: '_OffsetOf_item' value: 16rC!

NMLINK comment: 'NMLINK is the class of <ExternalStructure> which represent the Windows Common Control structure of the same name.

NMLINK accompanies link click notifications that are sent by the SysLink control, wrapped in Dolphin by <SysLinkView>.

	typedef struct tagNMLINK
	{
	    NMHDR       hdr;
	    LITEM     item ;
	} NMLINK,  *PNMLINK;'!

!NMLINK categoriesForClass!External-Data-Structured-Win32! !

!NMLINK methodsFor!

item
	"Answer the <LITEM> value of the receiver's 'item' field."

	^LITEM fromAddress: bytes yourAddress + _OffsetOf_item! !

!NMLINK categoriesForMethods!
item!**compiled accessors**!public! !
!

!NMLINK class methodsFor!

defineFields
	"Define the fields of the Win32 NMLINK structure
		NMLINK compileDefinition
	"

	super defineFields.	"NMHDR fields"
	self defineField: #item type: (StructureField type: LITEM) beReadOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #item)!

itemFromNMHDR: anExternalAddress
	^LITEM fromAddress: anExternalAddress yourAddress + _OffsetOf_item! !

!NMLINK class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
itemFromNMHDR:!public! !
!

