"Filed out from Dolphin Smalltalk X6.1"!

NMHDR subclass: #NMMOUSE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMMOUSE guid: (GUID fromString: '{E2A1EC3F-20B2-49CC-B90F-80F002A28204}')!
NMMOUSE comment: 'NMMOUSE is the class of <ExternalStructure> which represent the Windows Common Control structure of the same name.

NMMOUSE accompanies certain notifications that are sent by a control bars (e.g. toolbars, statusbars) when a mouse action occurs such as a click.
'!
!NMMOUSE categoriesForClass!External-Data-Structured-Win32! !
!NMMOUSE methodsFor!

dwHitInfo
	"Answer the receiver's dwHitInfo field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwHitInfo)!

dwItemData
	"Answer the receiver's dwItemData field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwItemData)!

dwItemSpec
	"Answer the receiver's dwItemSpec field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwItemSpec)!

iItem
	"Answer the item index (appropriate when originating from a control whose items
	are externally identified by integer keys)."

	^bytes sdwordAtOffset: 12!

position
	^self pt asPoint!

pt
	"Answer the receiver's pt field as a Smalltalk object."

	^POINTL fromAddress: bytes yourAddress + ##(self offsetOf: #pt)! !
!NMMOUSE categoriesFor: #dwHitInfo!**compiled accessors**!public! !
!NMMOUSE categoriesFor: #dwItemData!**compiled accessors**!public! !
!NMMOUSE categoriesFor: #dwItemSpec!**compiled accessors**!public! !
!NMMOUSE categoriesFor: #iItem!accessing!public! !
!NMMOUSE categoriesFor: #position!accessing!public! !
!NMMOUSE categoriesFor: #pt!**compiled accessors**!public! !

!NMMOUSE class methodsFor!

defineFields
	"Define the structure template for Win32 NMMOUSE structure.
		self compileDefinition
	"

	super defineFields.
	self 
		defineField: #dwItemSpec type: DWORDField readOnly;
		defineField: #dwItemData type: DWORDField readOnly;
		defineField: #pt type: (StructureField type: POINTL) beReadOnly;
		defineField: #dwHitInfo type: DWORDField readOnly! !
!NMMOUSE class categoriesFor: #defineFields!initializing!public! !

