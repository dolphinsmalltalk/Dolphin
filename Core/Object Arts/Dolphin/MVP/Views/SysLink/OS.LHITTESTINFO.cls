"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #LHITTESTINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_item' -> 16r8.
		'_OffsetOf_pt' -> 16r0
	}!
LHITTESTINFO guid: (GUID fromString: '{1498d0d0-6502-4ce2-8cf9-caa0625685ef}')!
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
!LHITTESTINFO categoriesFor: #item!**compiled accessors**!public! !
!LHITTESTINFO categoriesFor: #pt!**compiled accessors**!public! !
!LHITTESTINFO categoriesFor: #pt:!**compiled accessors**!public! !

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
!LHITTESTINFO class categoriesFor: #defineFields!public!template definition! !
!LHITTESTINFO class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

