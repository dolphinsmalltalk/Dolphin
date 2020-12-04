"Filed out from Dolphin Smalltalk 7"!

OS.NMHDR subclass: #'OS.NMLINK'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_item' -> 16rC
	}!
OS.NMLINK guid: (Core.GUID fromString: '{7caa2dd6-a6d4-493f-bdd4-39ef71f66221}')!
OS.NMLINK comment: 'NMLINK is the class of <ExternalStructure> which represent the Windows Common Control structure of the same name.

NMLINK accompanies link click notifications that are sent by the SysLink control, wrapped in Dolphin by <SysLinkView>.

	typedef struct tagNMLINK
	{
	    NMHDR       hdr;
	    LITEM     item ;
	} NMLINK,  *PNMLINK;'!
!OS.NMLINK categoriesForClass!External-Data-Structured-Win32! !
!OS.NMLINK methodsFor!

item
	"Answer the <LITEM> value of the receiver's 'item' field."

	^LITEM fromAddress: bytes yourAddress + _OffsetOf_item! !
!OS.NMLINK categoriesFor: #item!**compiled accessors**!public! !

!OS.NMLINK class methodsFor!

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
!OS.NMLINK class categoriesFor: #defineFields!public!template definition! !
!OS.NMLINK class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!OS.NMLINK class categoriesFor: #itemFromNMHDR:!public! !

