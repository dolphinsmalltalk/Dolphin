"Filed out from Dolphin Smalltalk"!

OS.Win32Structure subclass: #'OS.LHITTESTINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_LHITTESTINFO_Size' -> 16r10C0.
		'_OffsetOf_item' -> 16r8.
		'_OffsetOf_pt' -> 16r0
	}!
OS.LHITTESTINFO guid: (Core.GUID fromString: '{1498d0d0-6502-4ce2-8cf9-caa0625685ef}')!
OS.LHITTESTINFO comment: ''!
!OS.LHITTESTINFO categoriesForClass!External-Data-Structured-Win32! !
!OS.LHITTESTINFO methodsFor!

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
		to: ##(_OffsetOf_pt + POINTL._POINTL_Size)
		startingAt: 1! !
!OS.LHITTESTINFO categoriesForMethods!
item!**compiled accessors**!public! !
pt!**compiled accessors**!public! !
pt:!**compiled accessors**!public! !
!

!OS.LHITTESTINFO class methodsFor!

byteSize
	^_LHITTESTINFO_Size!

defineFields
	"Define the fields of the Win32 LITEM structure

		LHITTESTINFO compileDefinition
	"

	self
		defineField: #pt type: (StructureField type: POINTL);
		defineField: #item type: (StructureField type: LITEM) beReadOnly!

getFieldNames
	^#(#pt #item)! !
!OS.LHITTESTINFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

