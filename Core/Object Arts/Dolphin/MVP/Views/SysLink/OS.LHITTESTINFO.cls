"Filed out from Dolphin Smalltalk"!

OS.CCHITTESTINFO
	subclass: #'OS.LHITTESTINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_LHITTESTINFO_Size' -> 16r10C0. '_OffsetOf_item' -> 16r8 }!
OS.LHITTESTINFO guid: (Core.GUID fromString: '{1498d0d0-6502-4ce2-8cf9-caa0625685ef}')!
OS.LHITTESTINFO comment: ''!
!OS.LHITTESTINFO categoriesForClass!External-Data-Structured-Win32! !
!OS.LHITTESTINFO methodsFor!

handle
	"Private - Answer the item 'handle' associated with the receiver."

	^(bytes int32AtOffset: ##(_OffsetOf_item + LITEM._OffsetOf_iLink)) + 1!

item
	"Answer the <LITEM> value of the receiver's 'item' field."

	^LITEM fromAddress: bytes yourAddress + _OffsetOf_item! !
!OS.LHITTESTINFO categoriesForMethods!
handle!accessing!private! !
item!**compiled accessors**!public! !
!

!OS.LHITTESTINFO class methodsFor!

byteSize
	^_LHITTESTINFO_Size!

defineFields
	"Define the fields of the Win32 LITEM structure

		LHITTESTINFO compileDefinition
	"

	super defineFields.
	self defineField: #item type: (StructureField type: LITEM) beReadOnly!

getFieldNames
	^#(#pt #item)! !
!OS.LHITTESTINFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

