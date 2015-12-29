"Filed out from Dolphin Smalltalk X6.1"!

NMHDR subclass: #NMLINK
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMLINK guid: (GUID fromString: '{7CAA2DD6-A6D4-493F-BDD4-39EF71F66221}')!
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
	"Answer the receiver's item field as a Smalltalk object."

	^LITEM fromAddress: bytes yourAddress + ##(self offsetOf: #item)! !
!NMLINK categoriesFor: #item!**compiled accessors**!public! !

!NMLINK class methodsFor!

defineFields
	"Define the fields of the Win32 NMLINK structure
		NMLINK compileDefinition
	"

	super defineFields.	"NMHDR fields"
	self defineField: #item type: (StructureField type: LITEM) beReadOnly! !
!NMLINK class categoriesFor: #defineFields!initializing!public! !

