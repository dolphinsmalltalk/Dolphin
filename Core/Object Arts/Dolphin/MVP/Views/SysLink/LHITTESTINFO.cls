"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #LHITTESTINFO
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_item _OffsetOf_pt'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LHITTESTINFO guid: (GUID fromString: '{1498d0d0-6502-4ce2-8cf9-caa0625685ef}')!
LHITTESTINFO addClassConstant: '_OffsetOf_item' value: 16r8!
LHITTESTINFO addClassConstant: '_OffsetOf_pt' value: 16r0!
LHITTESTINFO comment: ''!
!LHITTESTINFO categoriesForClass!External-Data-Structured-Win32! !
!LHITTESTINFO methodsFor!

item
	"Answer the <LITEM> value of the receiver's 'item' field."

	^LITEM fromAddress: bytes yourAddress + _OffsetOf_item!

pt
	"Answer the <POINTL> value of the receiver's 'pt' field."

	^POINTL fromAddress: bytes yourAddress!

pt: aPOINTL
	"Set the receiver's 'pt' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_pt + 1)
		to: ##(_OffsetOf_pt + POINTL basicByteSize)
		startingAt: 1! !
!LHITTESTINFO categoriesForMethods!
item!**compiled accessors**!public! !
pt!**compiled accessors**!public! !
pt:!**compiled accessors**!public! !
!

!LHITTESTINFO class methodsFor!

defineFields
	"Define the fields of the Win32 LITEM structure

		LHITTESTINFO compileDefinition
	"

	self
		defineField: #pt type: (StructureField type:  POINTL);
		defineField: #item type: (StructureField type: LITEM) beReadOnly!

getFieldNames
	^#(#pt #item)! !
!LHITTESTINFO class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

